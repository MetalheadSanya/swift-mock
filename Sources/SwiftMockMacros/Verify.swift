import SwiftSyntax
import SwiftSyntaxBuilder

extension MockMacro {
	static func makeVerifyType(_ protocolDecl: ProtocolDeclSyntax) -> StructDeclSyntax {
		StructDeclSyntax(
			modifiers: DeclModifierListSyntax {
				DeclModifierSyntax(name: .keyword(.public))
			},
			name: "Verify",
			inheritanceClause: InheritanceClauseSyntax {
				InheritedTypeSyntax(type: IdentifierTypeSyntax(name: "MockVerify"))
			}
		) {
			makeVerifyStorageProperty(protocolDecl: protocolDecl)
			makeTimesStorageProperty()
			makeInit(protocolDecl: protocolDecl)
			for member in protocolDecl.memberBlock.members {
				if let funcDecl = member.decl.as(FunctionDeclSyntax.self) {
					makeVerifyMethod(protocolDecl: protocolDecl, funcDecl: funcDecl)
				}
			}
		}
	}
	
	private static func makeCallStorageProperyName(funcDecl: FunctionDeclSyntax) -> TokenSyntax {
		TokenSyntax.identifier(makeInvocationContainerName(from: funcDecl).text + "___call")
	}
	
	private static func makeGenericType(_ name: TokenSyntax, from funcDecl: FunctionDeclSyntax) -> some TypeSyntaxProtocol {
		return IdentifierTypeSyntax(
			name: name,
			genericArgumentClause: makeGenericArgumentClause(from: funcDecl)
		)
	}
	
	private static func makeGenericArgumentClause(from funcDecl: FunctionDeclSyntax) -> GenericArgumentClauseSyntax {
		GenericArgumentClauseSyntax {
			GenericArgumentSyntax(
				argument: packParametersToTupleType(funcDecl.signature.parameterClause.parameters)
			)
		}
	}
	
	private static func makeVerifyStorageProperty(protocolDecl: ProtocolDeclSyntax) -> VariableDeclSyntax {
		VariableDeclSyntax(
			.let,
			name: "mock",
			type: TypeAnnotationSyntax(
				type: IdentifierTypeSyntax(name: .identifier(protocolDecl.name.text + "Mock"))
			)
		)
	}
	
	private static func makeTimesStorageProperty() -> VariableDeclSyntax {
		VariableDeclSyntax(
			.let,
			name: "times",
			type: TypeAnnotationSyntax(
				type: IdentifierTypeSyntax(name: .identifier("TimesMatcher"))
			)
		)
	}
	
	private static func makeInit(protocolDecl: ProtocolDeclSyntax) -> InitializerDeclSyntax {
		InitializerDeclSyntax(
			modifiers: DeclModifierListSyntax {
				DeclModifierSyntax(name: .keyword(.public))
			},
			signature: FunctionSignatureSyntax(
				parameterClause: FunctionParameterClauseSyntax {
					"mock: \(raw: protocolDecl.name.text)Mock"
					"times: @escaping TimesMatcher"
				}
			),
			bodyBuilder: {
				"self.mock = mock"
				"self.times = times"
			}
		)
	}
	
	private static func makeVerifyMethod(protocolDecl: ProtocolDeclSyntax, funcDecl: FunctionDeclSyntax) -> FunctionDeclSyntax {
		funcDecl
			.with(\.modifiers, DeclModifierListSyntax {
				DeclModifierSyntax(name: .keyword(.public))
			})
			.with(\.signature, FunctionSignatureSyntax(
				parameterClause: wrapToArgumentMatcher(funcDecl.signature.parameterClause),
				returnClause: ReturnClauseSyntax(type: IdentifierTypeSyntax(name: .identifier("Void")))
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
				FunctionCallExprSyntax(
					calledExpression: MemberAccessExprSyntax(
						base: DeclReferenceExprSyntax(baseName: .identifier("MethodCall")),
						declName: DeclReferenceExprSyntax(baseName: .identifier("verify"))
					),
					leftParen: .leftParenToken(),
					rightParen: .rightParenToken()
				) {
					LabeledExprSyntax(
						label: "in",
						expression: MemberAccessExprSyntax(
							base: DeclReferenceExprSyntax(baseName: .identifier("mock")),
							declName: DeclReferenceExprSyntax(baseName: makeCallStorageProperyName(funcDecl: funcDecl))
						)
					)
					LabeledExprSyntax(
						label: "matcher",
						expression: DeclReferenceExprSyntax(baseName: parameters.isEmpty ? .identifier("any()") : .identifier("argumentMatcher0"))
					)
					LabeledExprSyntax(
						label: "times",
						expression: DeclReferenceExprSyntax(baseName: .identifier("times"))
					)
					LabeledExprSyntax(
						label: "type",
						expression: StringLiteralExprSyntax(content: protocolDecl.name.text + "Mock")
					)
				}
			})
	}
	
	static func makeCallStorageProperty(funcDecl: FunctionDeclSyntax) -> VariableDeclSyntax {
		let storageName = makeCallStorageProperyName(funcDecl: funcDecl)
		let invocationType = TokenSyntax.identifier("MethodCall")
		return VariableDeclSyntax(
			modifiers: DeclModifierListSyntax {
				DeclModifierSyntax(name: .keyword(.private))
			},
			bindingSpecifier: .keyword(.var),
			bindings: PatternBindingListSyntax {
				PatternBindingSyntax(
					pattern: IdentifierPatternSyntax(identifier: storageName),
					typeAnnotation: TypeAnnotationSyntax(type: ArrayTypeSyntax(element: makeGenericType(invocationType, from: funcDecl))),
					initializer: InitializerClauseSyntax(value: ArrayExprSyntax(expressions: []))
				)
			}
		)
	}
	
	static func makeStoreCallToStorageExpr(funcDecl: FunctionDeclSyntax) -> ExprSyntax {
		"\(makeCallStorageProperyName(funcDecl: funcDecl)).append(MethodCall(arguments: arguments))"
	}
}
