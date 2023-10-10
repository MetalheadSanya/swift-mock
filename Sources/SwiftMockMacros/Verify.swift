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
				} else if let variableDecl = member.decl.as(VariableDeclSyntax.self) {
					for decl in makeVerifyProperty(protocolDecl: protocolDecl, variableDecl: variableDecl) {
						decl
					}
				}
			}
		}
	}
	
	fileprivate static func makeMockTypeToken(_ protocolDecl: ProtocolDeclSyntax) -> TokenSyntax {
		return .identifier(protocolDecl.name.text + "Mock")
	}
	
	private static func makeVerifyStorageProperty(protocolDecl: ProtocolDeclSyntax) -> VariableDeclSyntax {
		VariableDeclSyntax(
			.let,
			name: "mock",
			type: TypeAnnotationSyntax(
				type: IdentifierTypeSyntax(name: makeMockTypeToken(protocolDecl))
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
	
	// MARK: - Vertify Method for Method
	
	private static func makeVerifyMethod(protocolDecl: ProtocolDeclSyntax, funcDecl: FunctionDeclSyntax) -> FunctionDeclSyntax {
		funcDecl
			.with(\.modifiers, DeclModifierListSyntax {
				publicModifier
			})
			.with(\.signature, FunctionSignatureSyntax(
				parameterClause: wrapToArgumentMatcher(funcDecl.signature.parameterClause),
				returnClause: ReturnClauseSyntax(type: IdentifierTypeSyntax(name: .identifier("Void")))
			))
			.with(\.body, makeVerifyBody(
				arguments: funcDecl.signature.parameterClause.parameters.map { $0.secondName ?? $0.firstName },
				storagePropertyToken: makeCallStorageProperyName(funcDecl: funcDecl),
				mockTypeToken: makeMockTypeToken(protocolDecl)
			))
	}
	
	private static func makeCallStorageProperyName(funcDecl: FunctionDeclSyntax) -> TokenSyntax {
		TokenSyntax.identifier(makeInvocationContainerName(from: funcDecl).text + "___call")
	}
	
	// MARK: - Verify Method For Property
	
	private static func makeVerifyProperty(protocolDecl: ProtocolDeclSyntax, variableDecl: VariableDeclSyntax) -> [DeclSyntax] {
		var declarations: [DeclSyntax] = []
		for bindingSyntax in variableDecl.bindings {
			guard let accessorBlock = bindingSyntax.accessorBlock else {
				// TODO: assertion
				continue
			}
			guard case let .`accessors`(accessorList) = accessorBlock.accessors else {
				// TODO: assertion
				continue
			}
			for accessorDecl in accessorList {
				let decl = DeclSyntax(
					fromProtocol: FunctionDeclSyntax(
						modifiers: DeclModifierListSyntax {
							publicModifier
						},
						name: makeVerifyPropertyToken(bindingSyntax: bindingSyntax, accessorDecl: accessorDecl),
						signature: makeVerifyPropertyFunctionSignature(bindingSyntax: bindingSyntax, accessorDecl: accessorDecl),
						body: makeVerifyBody(
							arguments: makeArgumentList(accessorDecl: accessorDecl),
							storagePropertyToken: makeCallStoragePropertyToken(bindingSyntax: bindingSyntax, accessorDecl: accessorDecl),
							mockTypeToken: makeMockTypeToken(protocolDecl)
						)
					)
				)
				declarations.append(decl)
			}
		}
		return declarations
	}
	
	private static func makeVerifyPropertyToken(
		bindingSyntax: PatternBindingSyntax,
		accessorDecl: AccessorDeclSyntax
	) -> TokenSyntax {
		guard var text = bindingSyntax.pattern.as(IdentifierPatternSyntax.self)?.identifier.text else {
			fatalError("Mock property unavailable for this declaration")
		}
		
		switch accessorDecl.accessorSpecifier.trimmed.text {
		case TokenSyntax.keyword(.get).text:
			text += "Getter"
		case TokenSyntax.keyword(.set).text:
			text += "Setter"
		default:
			fatalError("Unexpected accessor for property. Supported accessors: \"get\" and \"set\"")
		}
		
		return .identifier(text)
	}
	
	private static func makeVerifyPropertyFunctionSignature(
		bindingSyntax: PatternBindingSyntax,
		accessorDecl: AccessorDeclSyntax
	) -> FunctionSignatureSyntax {
		let propertyType = getBindingType(from: bindingSyntax)
		
		let functionParameterClause: FunctionParameterClauseSyntax
		switch accessorDecl.accessorSpecifier.trimmed.text {
		case TokenSyntax.keyword(.get).text:
			functionParameterClause = FunctionParameterClauseSyntax { }
		case TokenSyntax.keyword(.set).text:
			functionParameterClause = FunctionParameterClauseSyntax {
				FunctionParameterSyntax(
					firstName: .identifier("_"),
					secondName: .identifier("value"),
					type: wrapToEscapingType(
						type: wrapToArgumentMatcherType(type: propertyType)
					)
				)
			}
		default:
			fatalError("Unexpected accessor for property. Supported accessors: \"get\" and \"set\"")
		}
		
		return FunctionSignatureSyntax(parameterClause: functionParameterClause)
	}
	
	
	private static func makeCallStoragePropertyToken(
		bindingSyntax: PatternBindingSyntax,
		accessorDecl: AccessorDeclSyntax
	) -> TokenSyntax {
		let text: String
		switch accessorDecl.accessorSpecifier.trimmed.text {
		case TokenSyntax.keyword(.get).text:
			text = makeGetterInvocationContainerToken(from: bindingSyntax).text
		case TokenSyntax.keyword(.set).text:
			text = makeSetterInvocationContainerToken(from: bindingSyntax).text
		default:
			fatalError("Unexpected accessor for property. Supported accessors: \"get\" and \"set\"")
		}
		return .identifier(text + "___call")
	}
	
	private static func makeArgumentList(accessorDecl: AccessorDeclSyntax) -> [TokenSyntax] {
		switch accessorDecl.accessorSpecifier.trimmed.text {
		case TokenSyntax.keyword(.get).text:
			return []
		case TokenSyntax.keyword(.set).text:
			return [.identifier("value")]
		default:
			fatalError("Unexpected accessor for property. Supported accessors: \"get\" and \"set\"")
		}
	}
	
	// MARK: - General for Method and Property
	
	private static func makeVerifyBody(
		arguments: [TokenSyntax] = [],
		storagePropertyToken: TokenSyntax,
		mockTypeToken: TokenSyntax
	) -> CodeBlockSyntax {
		CodeBlockSyntax {
			for stmt in makeArgumentMatcherZipStmts(tokens: arguments) {
				stmt
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
						declName: DeclReferenceExprSyntax(baseName: storagePropertyToken)
					)
				)
				LabeledExprSyntax(
					label: "matcher",
					expression: DeclReferenceExprSyntax(baseName: arguments.isEmpty ? .identifier("any()") : .identifier("argumentMatcher0"))
				)
				LabeledExprSyntax(
					label: "times",
					expression: DeclReferenceExprSyntax(baseName: .identifier("times"))
				)
				LabeledExprSyntax(
					label: "type",
					expression: StringLiteralExprSyntax(content: mockTypeToken.text)
				)
			}
		}
	}
	
	// MARK: - Integration to other files
	
	static func makeCallStorageProperty(funcDecl: FunctionDeclSyntax) -> VariableDeclSyntax {
		let storageName = makeCallStorageProperyName(funcDecl: funcDecl)
		let parameterTypes = funcDecl.signature.parameterClause.parameters.map { $0.type }
		let storageType = ArrayTypeSyntax(element: makeMethodCallType(arguments: parameterTypes))
		return VariableDeclSyntax(
			modifiers: DeclModifierListSyntax {
				DeclModifierSyntax(name: .keyword(.private))
			},
			bindingSpecifier: .keyword(.var),
			bindings: PatternBindingListSyntax {
				PatternBindingSyntax(
					pattern: IdentifierPatternSyntax(identifier: storageName),
					typeAnnotation: TypeAnnotationSyntax(type: storageType),
					initializer: InitializerClauseSyntax(value: ArrayExprSyntax(expressions: []))
				)
			}
		)
	}
	
	static func makeStoreCallToStorageExpr(funcDecl: FunctionDeclSyntax) -> ExprSyntax {
		"\(makeCallStorageProperyName(funcDecl: funcDecl)).append(MethodCall(arguments: arguments))"
	}
	
	static func makeCallStorageProperty(
		bindingSyntax: PatternBindingSyntax,
		accessorDecl: AccessorDeclSyntax
	) -> DeclSyntax {
		let storageName = makeCallStoragePropertyToken(bindingSyntax: bindingSyntax, accessorDecl: accessorDecl)
		
		return DeclSyntax(
			fromProtocol: VariableDeclSyntax(
				modifiers: DeclModifierListSyntax {
					DeclModifierSyntax(name: .keyword(.private))
				},
				bindingSpecifier: .keyword(.var),
				bindings: PatternBindingListSyntax {
					PatternBindingSyntax(
						pattern: IdentifierPatternSyntax(identifier: storageName),
						typeAnnotation: TypeAnnotationSyntax(type: makeStorageType(bindingSyntax: bindingSyntax, accessorDecl: accessorDecl)),
						initializer: InitializerClauseSyntax(value: ArrayExprSyntax(expressions: []))
					)
				}
			)
		)
	}
	
	private static func makeStorageType(
		bindingSyntax: PatternBindingSyntax,
		accessorDecl: AccessorDeclSyntax
	) -> TypeSyntax {
		let elementType: TypeSyntax
		switch accessorDecl.accessorSpecifier.trimmed.text {
		case TokenSyntax.keyword(.get).text:
			elementType = TypeSyntax(
				fromProtocol: makeMethodCallType(
					arguments: []
				)
			)
		case TokenSyntax.keyword(.set).text:
			elementType = TypeSyntax(
				fromProtocol: makeMethodCallType(
					arguments: [
						getBindingType(from: bindingSyntax)
					]
				)
			)
		default:
			fatalError("Unexpected accessor for property. Supported accessors: \"get\" and \"set\"")
		}
		return TypeSyntax(fromProtocol: ArrayTypeSyntax(element: elementType))
	}
	
	static func makeStoreCallToStorageExpr(bindingSyntax: PatternBindingSyntax, accessorDecl: AccessorDeclSyntax) -> ExprSyntax {
		let storageToken = makeCallStoragePropertyToken(bindingSyntax: bindingSyntax, accessorDecl: accessorDecl)
		return "\(storageToken).append(MethodCall(arguments: arguments))"
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

}
