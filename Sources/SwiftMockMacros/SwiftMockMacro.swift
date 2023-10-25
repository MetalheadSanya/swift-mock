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
			
			return [
				DeclSyntax(
					try ClassDeclSyntax(
						attributes: makeMockDeclAttributes(protocolDecl: declaration),
						modifiers: DeclModifierListSyntax {
							if declaration.isPublic { .public }
							DeclModifierSyntax(name: .keyword(.final))
						},
						name: mockTypeToken,
						inheritanceClause: InheritanceClauseSyntax {
							if declaration.attributes.contains(where: { $0.isObjc }) { InheritedTypeSyntax(type: TypeSyntax.nsObject) }
							InheritedTypeSyntax(type: IdentifierTypeSyntax(name: declaration.name))
							InheritedTypeSyntax(type: IdentifierTypeSyntax(name: "Verifiable"))
						}
					) {
						try makeVerifyType(declaration)
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
		let prefix = makeTypePrefix(funcDecl: funcDecl)
		let signatureType = TokenSyntax.identifier(prefix + "MethodSignature")
		return funcDecl
			.with(\.modifiers, DeclModifierListSyntax {
				if isPublic { .public }
			})
			.with(\.name, TokenSyntax.identifier("$" + funcDecl.name.text))
			.with(\.signature, FunctionSignatureSyntax(
				parameterClause: wrapToArgumentMatcher(funcDecl.signature.parameterClause),
				returnClause: ReturnClauseSyntax(type: makeGenericType(signatureType, from: funcDecl))
			))
			.with(\.body, CodeBlockSyntax {
				let parameters = funcDecl.signature.parameterClause.parameters
				let mathers = parameters.map { $0.secondName ?? $0.firstName }
				for stmt in makeArgumentMatcherZipStmts(tokens: mathers) {
					stmt
				}
				ReturnStmtSyntax(
					expression: FunctionCallExprSyntax(
						calledExpression: GenericSpecializationExprSyntax(
							expression: DeclReferenceExprSyntax(baseName: signatureType),
							genericArgumentClause: makeGenericArgumentClause(from: funcDecl)
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
	
	private static func makeTypePrefix(funcDecl: FunctionDeclSyntax) -> String {
		var ownTypePrefix = ""
		if funcDecl.signature.effectSpecifiers?.asyncSpecifier != nil {
			ownTypePrefix += "Async"
		}
		if funcDecl.signature.effectSpecifiers?.throwsSpecifier != nil {
			ownTypePrefix += "Throws"
		}
		return ownTypePrefix
	}
	
	static func makeSyncTypePrefix(funcDecl: FunctionDeclSyntax) -> String {
		var ownTypePrefix = ""
		if funcDecl.signature.effectSpecifiers?.throwsSpecifier != nil {
			ownTypePrefix += "Throws"
		}
		return ownTypePrefix
	}
	
	private static func makeGenericType(_ name: TokenSyntax, from funcDecl: FunctionDeclSyntax) -> some TypeSyntaxProtocol {
		return IdentifierTypeSyntax(
			name: name,
			genericArgumentClause: makeGenericArgumentClause(from: funcDecl)
		)
	}
	
	static func wrapToArgumentMatcher(_ parameter: FunctionParameterSyntax) -> FunctionParameterSyntax {
		parameter
			.with(\.type, TypeSyntax(
				AttributedTypeSyntax(
					attributes: AttributeListSyntax {
						.attribute(AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier("escaping"))))
					},
					baseType: IdentifierTypeSyntax(
						name: .identifier("ArgumentMatcher"),
						genericArgumentClause: GenericArgumentClauseSyntax {
							GenericArgumentSyntax(argument: parameter.type)
						}
					)
				)
			))
			.with(\.defaultValue, InitializerClauseSyntax(
				value: FunctionCallExprSyntax(
					calledExpression: DeclReferenceExprSyntax(baseName: "any"),
					leftParen: .leftParenToken(),
					rightParen: .rightParenToken()
				) { }
			))
	}
	
	static func wrapToArgumentMatcher(_ parameterClause: FunctionParameterClauseSyntax) -> FunctionParameterClauseSyntax {
		parameterClause.with(\.parameters, FunctionParameterListSyntax {
			for parameter in parameterClause.parameters {
				wrapToArgumentMatcher(parameter)
			}
		})
	}
	
	private static func makeGenericArgumentClause(from funcDecl: FunctionDeclSyntax) -> GenericArgumentClauseSyntax {
		GenericArgumentClauseSyntax {
			GenericArgumentSyntax(
				argument: packParametersToTupleType(funcDecl.signature.parameterClause.parameters)
			)
			GenericArgumentSyntax(
				argument: funcDecl.signature.returnClause?.type ?? TypeSyntax(
					fromProtocol: IdentifierTypeSyntax(name: .identifier("Void")))
			)
		}
	}
	
	static func packParametersToTupleType<T: BidirectionalCollection>(
		_ parameterList: T
	) -> TupleTypeSyntax where T.Element == FunctionParameterSyntax  {
		if parameterList.count <= 1 {
			return TupleTypeSyntax(
				elements: TupleTypeElementListSyntax {
					for parameter in parameterList {
						TupleTypeElementSyntax(type: parameter.type)
					}
				}
			)
		} else {
			let rest = parameterList.dropFirst()
			return TupleTypeSyntax(
				elements: TupleTypeElementListSyntax {
					TupleTypeElementSyntax(type: parameterList.first!.type)
					TupleTypeElementSyntax(type: packParametersToTupleType(rest))
				}
			)
		}
	}
	
	static func packParametersToTupleExpr<T: BidirectionalCollection>(
		_ parameterList: T
	) -> TupleExprSyntax where T.Element == FunctionParameterSyntax  {
		if parameterList.count <= 1 {
			return TupleExprSyntax(
				elements: LabeledExprListSyntax {
					for parameter in parameterList {
						LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: parameter.secondName ?? parameter.firstName))
					}
				}
			)
		} else {
			let rest = parameterList.dropFirst()
			return TupleExprSyntax(
				elements: LabeledExprListSyntax {
					let parameter = parameterList.first!
					LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: parameter.secondName ?? parameter.firstName))
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
