//
//  Subscript.swift
//
//
//  Created by Alexandr Zalutskiy on 20/10/2023.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder

extension MockMacro {
	static func makeSubscriptMock(
		subscriptDecl: SubscriptDeclSyntax,
		mockTypeToken: TokenSyntax,
		isPublic: Bool
	) throws -> [DeclSyntax] {
		var declarations: [DeclSyntax] = []
		guard case let .`accessors`(accessorList) = subscriptDecl.accessorBlock?.accessors else {
			let diagnostic = Diagnostic(node: subscriptDecl, message: DiagnosticMessage.subscriptAccessorMustBeGetOrSet)
			throw DiagnosticError(diagnostic: diagnostic)
		}
		for accessorDecl in accessorList {
			declarations.append(try makeInvocationContainerProperty(subscriptDecl: subscriptDecl, accessorDecl: accessorDecl))
			declarations.append(try makeSignatureMethod(subscriptDecl: subscriptDecl, accessorDecl: accessorDecl, isPublic: isPublic))
		}
		declarations.append(try makeMockProperty(subscriptDecl: subscriptDecl, mockTypeToken: mockTypeToken, isPublic: isPublic))
		return declarations
	}
	
	// MARK: - Making Invocation Container
	
	private static func makeInvocationContainerProperty(
		subscriptDecl: SubscriptDeclSyntax,
		accessorDecl: AccessorDeclSyntax
	) throws -> DeclSyntax {
		let bindings = try makeInvocationContainerPatternBindingList(
			subscriptDecl: subscriptDecl,
			accessorDecl: accessorDecl
		)
		return DeclSyntax(
			fromProtocol: VariableDeclSyntax(
				modifiers: DeclModifierListSyntax {
					privateModifier
				},
				bindingSpecifier: .keyword(.let),
				bindings: bindings
			)
		)
	}
	
	private static func makeInvocationContainerPatternBindingList(
		subscriptDecl: SubscriptDeclSyntax,
		accessorDecl: AccessorDeclSyntax
	) throws -> PatternBindingListSyntax {
		try PatternBindingListSyntax {
			try makeInvocationContainerPatterBindingSyntax(subscriptDecl: subscriptDecl, accessorDecl: accessorDecl)
		}
	}
	
	private static func makeInvocationContainerPatterBindingSyntax(
		subscriptDecl: SubscriptDeclSyntax,
		accessorDecl: AccessorDeclSyntax
	) throws -> PatternBindingSyntax {
		PatternBindingSyntax(
			pattern: try makeInvocationContainerPattern(subscriptDecl: subscriptDecl, accessorDecl: accessorDecl),
			initializer: makeMethodInvocationContainerInitializerClause(isAsync: false, isThrows: false, isRethrows: false)
		)
	}
	
	private static func makeInvocationContainerPattern(
		subscriptDecl: SubscriptDeclSyntax,
		accessorDecl: AccessorDeclSyntax
	) throws -> PatternSyntax {
		let token = try makeInvocationContainerToken(subscriptDecl: subscriptDecl, accessorDecl: accessorDecl)
		return PatternSyntax(
			IdentifierPatternSyntax(identifier: token)
		)
	}
	
	// MARK: - Making the Signature Method
	
	private static func makeSignatureMethod(
		subscriptDecl: SubscriptDeclSyntax,
		accessorDecl: AccessorDeclSyntax,
		isPublic: Bool
	) throws -> DeclSyntax {
		if accessorDecl.isGet {
			return try makeGetterSignatureMethod(
				subscriptDecl: subscriptDecl,
				isPublic: isPublic
			)
		} else if accessorDecl.isSet {
			return try makeSetterSignatureMethod(
				subscriptDecl: subscriptDecl,
				isPublic: isPublic
			)
		} else {
			let diagnostic = Diagnostic(node: accessorDecl, message: DiagnosticMessage.subscriptAccessorMustBeGetOrSet)
			throw DiagnosticError(diagnostic: diagnostic)
		}
	}
	
	// MARK: - Making the Getter Signature Method
	
	private static func makeGetterSignatureMethod(
		subscriptDecl: SubscriptDeclSyntax,
		isPublic: Bool
	) throws -> DeclSyntax {
		let returnType = subscriptDecl.returnClause.type.trimmed
		let containerToken = try makeInvocationContainerToken(subscriptDecl: subscriptDecl, accessorDecl: "get")
		return DeclSyntax(
			fromProtocol: FunctionDeclSyntax(
				modifiers: DeclModifierListSyntax {
					if isPublic { .public }
				},
				name: makeGetterSignatureMethodName(),
				genericParameterClause: subscriptDecl.genericParameterClause,
				signature: FunctionSignatureSyntax(
					parameterClause: wrapToArgumentMatcher(subscriptDecl.parameterClause),
					returnClause: makeGetterSignatureMethodReturnClause(
						subscriptDecl: subscriptDecl
					)
				),
				genericWhereClause: subscriptDecl.genericWhereClause
			) {
				let parameters = subscriptDecl.parameterClause.parameters
				let mathers = parameters.map { $0.secondName ?? $0.firstName }
				for stmt in makeArgumentMatcherZipStmts(tokens: mathers) {
					stmt
				}
				ReturnStmtSyntax(
					expression: FunctionCallExprSyntax(
						calledExpression: makeMethodSignatureExpr(
							arguments: subscriptDecl.parameterClause.parameters.map(\.type),
							returnType: returnType
						),
						leftParen: .leftParenToken(),
						rightParen: .rightParenToken()
					) {
						LabeledExprSyntax(
							label: "argumentMatcher",
							expression: ExprSyntax(stringLiteral: "argumentMatcher0")
						)
						makeMethodSignatureRegisterLabeledExpr(from: containerToken)
					}
				)
			}
		)
	}
	
	private static func makeGetterSignatureMethodName() -> TokenSyntax {
		return .identifier("$subscriptGetter")
	}
	
	private static func makeGetterSignatureMethodReturnClause(
		subscriptDecl: SubscriptDeclSyntax
	) -> ReturnClauseSyntax {
		let argumentTypes = subscriptDecl.parameterClause.parameters.map(\.type)
		let returnType = subscriptDecl.returnClause.type.trimmed
		return ReturnClauseSyntax(
			type: makeMethodSignatureType(
				arguments: argumentTypes,
				returnType: returnType
			)
		)
	}
	
	// MARK: - Making the Setter Signature Method
	
	private static func makeSetterSignatureMethod(
		subscriptDecl: SubscriptDeclSyntax,
		isPublic: Bool
	) throws -> DeclSyntax {
		let returnType = subscriptDecl.returnClause.type.trimmed
		let containerToken = try makeInvocationContainerToken(subscriptDecl: subscriptDecl, accessorDecl: "set")
		let parameterTokens = subscriptDecl.parameterClause.parameters.map { $0.secondName ?? $0.firstName }
		let parameterTypes = subscriptDecl.parameterClause.parameters.map(\.type)
		return DeclSyntax(
			fromProtocol: FunctionDeclSyntax(
				modifiers: DeclModifierListSyntax {
					if isPublic { .public }
				},
				name: makeSetterSignatureMethodName(),
				genericParameterClause: subscriptDecl.genericParameterClause,
				signature: FunctionSignatureSyntax(
					parameterClause: FunctionParameterClauseSyntax {
						for parameter in subscriptDecl.parameterClause.parameters {
							wrapToArgumentMatcher(parameter)
						}
						FunctionParameterSyntax(
							firstName: TokenSyntax.identifier("newValue"),
							type: wrapToEscapingType(type: wrapToArgumentMatcherType(type: returnType)),
							defaultValue: InitializerClauseSyntax(value: anyFunctionCallExpr)
						)
					},
					returnClause: makeSetterSignatureMethodReturnClause(subscriptDecl: subscriptDecl)
				),
				genericWhereClause: subscriptDecl.genericWhereClause
			) {
				for stmt in makeArgumentMatcherZipStmts(tokens: parameterTokens + [TokenSyntax.identifier("newValue")]) {
					stmt
				}
				ReturnStmtSyntax(
					expression: FunctionCallExprSyntax(
						calledExpression: makeMethodSignatureExpr(arguments: parameterTypes + [returnType]),
						leftParen: .leftParenToken(),
						rightParen: .rightParenToken()
					) {
						LabeledExprSyntax(
							label: "argumentMatcher",
							expression: DeclReferenceExprSyntax(baseName: .identifier("argumentMatcher0"))
						)
						makeMethodSignatureRegisterLabeledExpr(from: containerToken)
					}
				)
			}
		)
	}
	
	private static func makeSetterSignatureMethodName() -> TokenSyntax {
		return .identifier("$subscriptSetter")
	}
	
	private static func makeSetterSignatureMethodReturnClause(subscriptDecl: SubscriptDeclSyntax) -> ReturnClauseSyntax {
		let returnType = subscriptDecl.returnClause.type.trimmed
		let parameterTypes = subscriptDecl.parameterClause.parameters.map(\.type)
		return ReturnClauseSyntax(
			type: makeMethodSignatureType(arguments: parameterTypes + [returnType])
		)
	}
	
	// MARK: - General Factory Methods
	
	private static func makeInvocationContainerToken(
		subscriptDecl: SubscriptDeclSyntax,
		accessorDecl: AccessorDeclSyntax
	) throws -> TokenSyntax {
		var tokenText = subscriptDecl.makeInvocationContainerBaseNameToken().text
		if accessorDecl.isGet {
			tokenText += "___getter"
		} else if accessorDecl.isSet {
			tokenText += "___setter"
		} else {
			let diagnostic = Diagnostic(node: accessorDecl, message: DiagnosticMessage.subscriptAccessorMustBeGetOrSet)
			throw DiagnosticError(diagnostic: diagnostic)
		}
		return .identifier(tokenText)
	}
	
	// MARK: - Making the Mock Subscript
	
	private static func makeMockProperty(
		subscriptDecl: SubscriptDeclSyntax,
		mockTypeToken: TokenSyntax,
		isPublic: Bool
	) throws -> DeclSyntax {
		let getAccessorDecl: AccessorDeclSyntax = "get"
		let returnValue = try makeMockGetterReturnExpr(
			subscriptDecl: subscriptDecl,
			mockTypeToken: mockTypeToken
		)
		var accessorDeclListSyntax = AccessorDeclListSyntax {
			getAccessorDecl.with(\.body, CodeBlockSyntax {
				let argumentsExpression = packParametersToTupleExpr(subscriptDecl.parameterClause.parameters)
				"let arguments = \(argumentsExpression)"
				makeStoreCallToStorageExpr(subscriptDecl: subscriptDecl)
				ReturnStmtSyntax(
					expression: returnValue
				)
			})
		}
		guard let accessorBlock = subscriptDecl.accessorBlock else {
			let diagnostic = Diagnostic(node: subscriptDecl, message: DiagnosticMessage.subscriptAccessorMustBeGetOrSet)
			throw DiagnosticError(diagnostic: diagnostic)
		}
		guard case let .`accessors`(accessors) = accessorBlock.accessors else {
			let diagnostic = Diagnostic(node: accessorBlock, message: DiagnosticMessage.subscriptAccessorMustBeGetOrSet)
			throw DiagnosticError(diagnostic: diagnostic)
		}
		let hasSetter = accessors.reduce(false) {
			$0 || $1.accessorSpecifier.trimmed.text == TokenSyntax.keyword(.set).text
		}
		if hasSetter {
			accessorDeclListSyntax.append(
				try AccessorDeclSyntax(
					accessorSpecifier: .keyword(.set)
				) {
					let paramters = subscriptDecl.parameterClause.parameters
					let extendedParameters = paramters + [
						FunctionParameterSyntax(
							firstName: "newValue",
							type: subscriptDecl.returnClause.type.trimmed
						)
					]
					let argumentsExpression = packParametersToTupleExpr(extendedParameters)
					"let arguments = \(argumentsExpression)"
					makeStoreCallToStorageExpr(subscriptDecl: subscriptDecl)
					ReturnStmtSyntax(
						expression: try makeMockSetterReturnExpr(
							subscriptDecl: subscriptDecl,
							mockTypeToken: mockTypeToken
						)
					)
				}
			)
		}
		return DeclSyntax(
			fromProtocol: subscriptDecl
				.with(\.modifiers, DeclModifierListSyntax {
					if isPublic { .public }
				})
				.with(\.accessorBlock, AccessorBlockSyntax(
					accessors: .accessors(accessorDeclListSyntax)
				))
		)
	}
	
	private static func makeMockGetterReturnExpr(
		subscriptDecl: SubscriptDeclSyntax,
		mockTypeToken: TokenSyntax
	) throws -> ExprSyntax {
		let propertySignatureString = makeSubscriptSignatureString(subscriptDecl: subscriptDecl)
		let containerToken = try makeInvocationContainerToken(subscriptDecl: subscriptDecl, accessorDecl: "get")
		return ExprSyntax(
			fromProtocol: FunctionCallExprSyntax(
				calledExpression: MemberAccessExprSyntax(
					base: DeclReferenceExprSyntax(baseName: containerToken),
					declName: DeclReferenceExprSyntax(baseName: .identifier("find"))
				),
				leftParen: .leftParenToken(),
				rightParen: .rightParenToken()
			) {
				LabeledExprSyntax(
					label: "with",
					expression: DeclReferenceExprSyntax(baseName: .identifier("arguments"))
				)
				LabeledExprSyntax(
					label: "type",
					expression: StringLiteralExprSyntax(content: mockTypeToken.text)
				)
				LabeledExprSyntax(
					label: "function",
					expression: ExprSyntax(literal: propertySignatureString)
				)
			}
		)
	}
	
	private static func makeMockSetterReturnExpr(
		subscriptDecl: SubscriptDeclSyntax,
		mockTypeToken: TokenSyntax
	) throws -> ExprSyntax {
		let containerToken = try makeInvocationContainerToken(subscriptDecl: subscriptDecl, accessorDecl: "set")
		let propertySignatureString = makeSubscriptSignatureString(subscriptDecl: subscriptDecl)
		return ExprSyntax(
			fromProtocol: FunctionCallExprSyntax(
				calledExpression: MemberAccessExprSyntax(
					base: DeclReferenceExprSyntax(baseName: containerToken),
					declName: DeclReferenceExprSyntax(baseName: .identifier("find"))
				),
				leftParen: .leftParenToken(),
				rightParen: .rightParenToken()
			) {
				LabeledExprSyntax(
					label: "with",
					expression: DeclReferenceExprSyntax(baseName: .identifier("arguments"))
				)
				LabeledExprSyntax(
					label: "type",
					expression: StringLiteralExprSyntax(content: mockTypeToken.text)
				)
				LabeledExprSyntax(
					label: "function",
					expression: ExprSyntax(literal: propertySignatureString)
				)
			}
		)
	}
}
