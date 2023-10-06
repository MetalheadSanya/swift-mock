import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct MockMacro: PeerMacro {
	public static func expansion(
		of node: SwiftSyntax.AttributeSyntax,
		providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
		in context: some SwiftSyntaxMacros.MacroExpansionContext
	) throws -> [SwiftSyntax.DeclSyntax] {
		guard let declaration = declaration.as(ProtocolDeclSyntax.self) else {
			fatalError("Mock macro can be attached only to a protocol type")
		}
		guard declaration.modifiers.contains(where: { $0.name.text == TokenSyntax.keyword(.public).text }) else {
			fatalError("Mock macro can be attached only to a public type")
		}
		
		let mockTypeToken = TokenSyntax.identifier(declaration.name.text + "Mock")
		
		return [
			DeclSyntax(
				ClassDeclSyntax(
					modifiers: DeclModifierListSyntax {
						DeclModifierSyntax(name: .keyword(.public))
						DeclModifierSyntax(name: .keyword(.final))
					},
					name: mockTypeToken,
					inheritanceClause: InheritanceClauseSyntax {
						InheritedTypeSyntax(type: IdentifierTypeSyntax(name: declaration.name))
						InheritedTypeSyntax(type: IdentifierTypeSyntax(name: "Verifiable"))
					}
				) {
					makeVerifyType(declaration)
					for member in declaration.memberBlock.members {
						if let funcDecl = member.decl.as(FunctionDeclSyntax.self) {
							makeInvocationContainerProperty(funcDecl: funcDecl)
							makeCallStorageProperty(funcDecl: funcDecl)
							makeSignatureMethod(from: funcDecl)
							funcDecl
								.with(\.modifiers, DeclModifierListSyntax {
									DeclModifierSyntax(name: .keyword(.public))
								})
								.with(\.body, makeMockMethodBody(from: funcDecl, type: mockTypeToken))
						}
					}
				}
			)
		]
	}
	
	private static func makeInvocationContainerProperty(funcDecl: FunctionDeclSyntax) -> VariableDeclSyntax {
		let prefix = makeTypePrefix(funcDecl: funcDecl)
		let invocationType = TokenSyntax.identifier(prefix + "MethodInvocation")
		return VariableDeclSyntax(
			modifiers: DeclModifierListSyntax {
				DeclModifierSyntax(name: .keyword(.private))
			},
			bindingSpecifier: .keyword(.var),
			bindings: PatternBindingListSyntax {
				PatternBindingSyntax(
					pattern: IdentifierPatternSyntax(identifier: makeInvocationContainerName(from: funcDecl)),
					typeAnnotation: TypeAnnotationSyntax(type: ArrayTypeSyntax(element: makeGenericType(invocationType, from: funcDecl))),
					initializer: InitializerClauseSyntax(value: ArrayExprSyntax(expressions: []))
				)
			}
		)
	}
	
	private static func makeSignatureMethod(from funcDecl: FunctionDeclSyntax) -> FunctionDeclSyntax {
		let prefix = makeTypePrefix(funcDecl: funcDecl)
		let signatureType = TokenSyntax.identifier(prefix + "MethodSignature")
		return funcDecl
			.with(\.modifiers, DeclModifierListSyntax {
				DeclModifierSyntax(name: .keyword(.public))
			})
			.with(\.name, TokenSyntax.identifier("$" + funcDecl.name.text))
			.with(\.signature, FunctionSignatureSyntax(
				parameterClause: wrapToArgumentMatcher(funcDecl.signature.parameterClause),
				returnClause: ReturnClauseSyntax(type: makeGenericType(signatureType, from: funcDecl))
			))
			.with(\.body, CodeBlockSyntax {
				let parameters = funcDecl.signature.parameterClause.parameters
				for (index, parameter) in parameters.enumerated().reversed() {
					if index == parameters.count - 1 {
						"let argumentMatcher\(raw: index) = \(raw: parameter.secondName ?? parameter.firstName)"
					} else {
						"let argumentMatcher\(raw: index) = zip(\(raw: parameter.secondName ?? parameter.firstName), argumentMatcher\(raw: index + 1))"
					}
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
						if parameters.isEmpty {
							LabeledExprSyntax(
								label: "argumentMatcher",
								expression: FunctionCallExprSyntax(
									calledExpression: DeclReferenceExprSyntax(
										baseName: .identifier("any")
									),
									leftParen: .leftParenToken(),
									rightParen: .rightParenToken()
								) { }
							)
						} else {
							LabeledExprSyntax(
								label: "argumentMatcher",
								expression: DeclReferenceExprSyntax(baseName: .identifier("argumentMatcher0"))
							)
						}
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
	
	private static func makeMockMethodBody(from funcDecl: FunctionDeclSyntax, type: TokenSyntax) -> CodeBlockSyntax {
		let prefix = makeTypePrefix(funcDecl: funcDecl)
		let invocationType = TokenSyntax.identifier(prefix + "MethodInvocation")
		let argumentsExpression = packParametersToTupleExpr(funcDecl.signature.parameterClause.parameters)
		let functionCallExpr = FunctionCallExprSyntax(
			calledExpression: MemberAccessExprSyntax(
				base: DeclReferenceExprSyntax(baseName: invocationType),
				declName: DeclReferenceExprSyntax(baseName: .identifier("find"))
			),
			leftParen: .leftParenToken(),
			rightParen: .rightParenToken()
		) {
			LabeledExprSyntax(
				label: "in",
				expression: DeclReferenceExprSyntax(baseName: makeInvocationContainerName(from: funcDecl))
			)
			LabeledExprSyntax(
				label: "with",
				expression: DeclReferenceExprSyntax(baseName: .identifier("arguments"))
			)
			LabeledExprSyntax(
				label: "type",
				expression: StringLiteralExprSyntax(content: type.text)
			)
		}
		return CodeBlockSyntax {
			"let arguments = \(argumentsExpression)"
			makeStoreCallToStorageExpr(funcDecl: funcDecl)
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
	
	private static func wrapToArgumentMatcher(_ parameter: FunctionParameterSyntax) -> FunctionParameterSyntax {
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
	
	private static func packParametersToTupleExpr<T: BidirectionalCollection>(
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
