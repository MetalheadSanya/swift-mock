import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct MockMacro: PeerMacro {
	public static func expansion(
		of node: SwiftSyntax.AttributeSyntax,
		providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
		in context: some SwiftSyntaxMacros.MacroExpansionContext
	) throws -> [SwiftSyntax.DeclSyntax] {
		do {
			let declaration = try Diagnostic.extractProtocolDecl(declaration)
			try Diagnostic.validateProtocolDecl(declaration)
			
			let mockTypeToken = TokenSyntax.identifier(declaration.name.text + "Mock")
			
			let associatedTypeDecls = declaration.memberBlock.members
				.compactMap { $0.decl.as(AssociatedTypeDeclSyntax.self) }
			
			return [
				DeclSyntax(
					try ClassDeclSyntax(
						attributes: makeMockDeclAttributes(protocolDecl: declaration),
						modifiers: DeclModifierListSyntax {
							if declaration.isPublic { .public }
							DeclModifierSyntax(name: .keyword(.final))
						},
						name: mockTypeToken,
						genericParameterClause: try AssociatedTypePrecessor.makeGenericParameterClause(associatedTypeDecls: associatedTypeDecls),
						inheritanceClause: InheritanceClauseSyntax {
							if declaration.attributes.contains(where: { $0.isObjc }) { InheritedTypeSyntax(type: TypeSyntax.nsObject) }
							InheritedTypeSyntax(type: IdentifierTypeSyntax(name: declaration.name))
							InheritedTypeSyntax(type: IdentifierTypeSyntax(name: "Verifiable"))
						}
					) {
						try makeVerifyType(declaration)
						if declaration.isPublic { makePublicInit() }
						try makeVerifyCallStorageProperty(isPublic: declaration.isPublic)
						for member in declaration.memberBlock.members {
							if let subscriptDecl = member.decl.as(SubscriptDeclSyntax.self) {
								for decl in try makeSubscriptMock(subscriptDecl: subscriptDecl, mockTypeToken: mockTypeToken, isPublic: declaration.isPublic) {
									decl
								}
							} else if let funcDecl = member.decl.as(FunctionDeclSyntax.self) {
								makeInvocationContainerProperty(funcDecl: funcDecl)
								makeSignatureMethod(from: funcDecl, isPublic: declaration.isPublic)
								funcDecl
									.with(\.leadingTrivia, Trivia(pieces: []))
									.with(\.attributes, MethodProcessor.makeMockMethodArrtibutes(functionDecl: funcDecl))
									.with(\.modifiers, DeclModifierListSyntax {
										if declaration.isPublic { .public }
									})
									.with(\.body, try makeMockMethodBody(from: funcDecl, type: mockTypeToken))
							} else if let variableDecl = member.decl.as(VariableDeclSyntax.self) {
								for decl in try makeVariableMock(from: variableDecl, mockTypeToken: mockTypeToken, isPublic: declaration.isPublic) {
									decl
								}
							}
						}
					}
				)
			]
		} catch let error as DiagnosticError {
			context.diagnose(error.diagnostic)
			return []
		} catch {
			throw error
		}
	}
	
	private static func makePublicInit() -> DeclSyntax {
		DeclSyntax(
			InitializerDeclSyntax(
				modifiers: DeclModifierListSyntax {
					.public
				},
				signature: FunctionSignatureSyntax(
					parameterClause: FunctionParameterClauseSyntax(
						parameters: []
					)
				),
				bodyBuilder: { }
			)
		)
	}
	
	private static func makeInvocationContainerProperty(funcDecl: FunctionDeclSyntax) -> VariableDeclSyntax {
		return VariableDeclSyntax(
			modifiers: DeclModifierListSyntax {
				DeclModifierSyntax(name: .keyword(.private))
			},
			bindingSpecifier: .keyword(.let),
			bindings: PatternBindingListSyntax {
				PatternBindingSyntax(
					pattern: IdentifierPatternSyntax(identifier: makeInvocationContainerName(from: funcDecl)),
					initializer: makeMethodInvocationContainerInitializerClause(
						isAsync: funcDecl.isAsync,
						isThrows: funcDecl.isThrows
					)
				)
			}
		)
	}
	
	private static func makeSignatureMethod(
		from funcDecl: FunctionDeclSyntax,
		isPublic: Bool
	) -> FunctionDeclSyntax {
		return funcDecl
			.with(\.attributes, MethodProcessor.makeSignatureMethodAttributes(functionDecl: funcDecl))
			.with(\.modifiers, DeclModifierListSyntax {
				if isPublic { .public }
			})
			.with(\.name, TokenSyntax.identifier("$" + funcDecl.name.text))
			.with(\.signature, FunctionSignatureSyntax(
				parameterClause: wrapToArgumentMatcher(funcDecl.signature.parameterClause),
				returnClause: ReturnClauseSyntax(
					type: makeMethodSignatureType(
						isAsync: funcDecl.isAsync,
						isThrows: funcDecl.isThrows,
						arguments: funcDecl.signature.parameterClause.parameters.map(\.type),
						returnType: funcDecl.signature.returnClause?.type
					)
				)
			))
			.with(\.body, CodeBlockSyntax {
				let parameters = funcDecl.signature.parameterClause.parameters
				let mathers = parameters.map { $0.secondName ?? $0.firstName }
				for stmt in makeArgumentMatcherZipStmts(tokens: mathers) {
					stmt
				}
				ReturnStmtSyntax(
					expression: FunctionCallExprSyntax(
						calledExpression: makeMethodSignatureExpr(
							isAsync: funcDecl.isAsync,
							isThrows: funcDecl.isThrows,
							arguments: funcDecl.signature.parameterClause.parameters.map(\.type),
							returnType: funcDecl.signature.returnClause?.type
						),
						leftParen: .leftParenToken(),
						rightParen: .rightParenToken()
					) {
						LabeledExprSyntax(
							label: "argumentMatcher",
							expression: ExprSyntax(stringLiteral: "argumentMatcher0")
						)
						LabeledExprSyntax(
							label: "register",
							expression: ClosureExprSyntax {
								FunctionCallExprSyntax(
									calledExpression: MemberAccessExprSyntax(
										base: MemberAccessExprSyntax(
											base: DeclReferenceExprSyntax(baseName: TokenSyntax.keyword(.`self`)),
											declName: DeclReferenceExprSyntax(baseName: makeInvocationContainerName(from: funcDecl))
										),
										declName: DeclReferenceExprSyntax(baseName: .identifier("append"))
									),
									leftParen: .leftParenToken(),
									rightParen: .rightParenToken()
								) {
									LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: .identifier("$0")))
								}
							}
						)
					}
				)
			})
	}
	
	private static func makeMockMethodBody(from funcDecl: FunctionDeclSyntax, type: TokenSyntax) throws -> CodeBlockSyntax {
		let argumentsExpression = packParametersToTupleExpr(funcDecl.signature.parameterClause.parameters)
		let funcSignatureString = try makeFunctionSignatureString(funcDecl: funcDecl)
		let invocationContainerToken = makeInvocationContainerName(from: funcDecl)
		let functionCallExpr = FunctionCallExprSyntax(
			calledExpression: MemberAccessExprSyntax(
				base: DeclReferenceExprSyntax(baseName: invocationContainerToken),
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
				expression: StringLiteralExprSyntax(content: type.text)
			)
			LabeledExprSyntax(
				label: "function",
				expression: ExprSyntax(literal: funcSignatureString)
			)
		}
		return try CodeBlockSyntax {
			"let arguments = \(argumentsExpression)"
			try makeStoreCallToStorageExpr(funcDecl: funcDecl)
			if funcDecl.signature.effectSpecifiers?.throwsSpecifier != nil {
				if funcDecl.signature.effectSpecifiers?.asyncSpecifier != nil {
					ReturnStmtSyntax(
						expression: TryExprSyntax(
							expression: AwaitExprSyntax(
								expression: functionCallExpr
							)
						)
					)
				} else {
					ReturnStmtSyntax(
						expression: TryExprSyntax(
							expression: functionCallExpr
						)
					)
				}
			} else if funcDecl.signature.effectSpecifiers?.asyncSpecifier != nil {
				ReturnStmtSyntax(
					expression: AwaitExprSyntax(expression: functionCallExpr)
				)
			} else {
				ReturnStmtSyntax(
					expression: functionCallExpr
				)
			}
		}
	}
	
	static func wrapToArgumentMatcher(_ parameter: FunctionParameterSyntax) -> FunctionParameterSyntax {
		FunctionParameterSyntax(
			firstName: parameter.firstName,
			secondName: parameter.secondName,
			type: wrapToEscapingType(type: wrapToArgumentMatcherType(type: parameter.type)),
			defaultValue: InitializerClauseSyntax(value: anyFunctionCallExpr)
		)
	}
	
	static func wrapToArgumentMatcher(_ parameterClause: FunctionParameterClauseSyntax) -> FunctionParameterClauseSyntax {
		parameterClause.with(\.parameters, FunctionParameterListSyntax {
			for parameter in parameterClause.parameters {
				wrapToArgumentMatcher(parameter)
			}
		})
	}
	
	static func packParametersToTupleExpr<T: BidirectionalCollection>(
		_ parameterList: T
	) -> TupleExprSyntax where T.Element == FunctionParameterSyntax  {
		func packParameter(functionParameter: FunctionParameterSyntax) -> ExprSyntax {
			if functionParameter.type.as(FunctionTypeSyntax.self) != nil {
				return "NonEscapingFunction()"
			}
			return ExprSyntax(
				DeclReferenceExprSyntax(baseName: functionParameter.secondName ?? functionParameter.firstName)
			)
		}
		
		if parameterList.count <= 1 {
			return TupleExprSyntax(
				elements: LabeledExprListSyntax {
					for parameter in parameterList {
						LabeledExprSyntax(expression: packParameter(functionParameter: parameter))
					}
				}
			)
		} else {
			let rest = parameterList.dropFirst()
			return TupleExprSyntax(
				elements: LabeledExprListSyntax {
					let decl = packParameter(functionParameter: parameterList.first!)
					LabeledExprSyntax(expression: decl)
					LabeledExprSyntax(expression: packParametersToTupleExpr(rest))
				}
			)
		}
	}
	
	static func makeInvocationContainerName(from funcDecl: FunctionDeclSyntax) -> TokenSyntax {
		var name = ""
		name += funcDecl.name.text
		name += "_"
		for parameter in funcDecl.signature.parameterClause.parameters {
			name += parameter.firstName.text
			name += "_"
		}
		if funcDecl.signature.parameterClause.parameters.isEmpty {
			name += "_"
		}
		if let token = funcDecl.signature.effectSpecifiers?.asyncSpecifier {
			name += token.text
		}
		if let token = funcDecl.signature.effectSpecifiers?.throwsSpecifier {
			name += token.text
		}
		return TokenSyntax.identifier(name)
	}
}

@main
struct SwiftMockPlugin: CompilerPlugin {
	let providingMacros: [Macro.Type] = [
		MockMacro.self,
	]
}
