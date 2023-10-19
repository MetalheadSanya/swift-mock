import SwiftSyntax
import SwiftSyntaxBuilder

extension MockMacro {
	static func makeVerifyType(_ protocolDecl: ProtocolDeclSyntax) throws -> StructDeclSyntax {
		try StructDeclSyntax(
			modifiers: DeclModifierListSyntax {
				if protocolDecl.isPublic { .public }
			},
			name: "Verify",
			inheritanceClause: InheritanceClauseSyntax {
				InheritedTypeSyntax(type: IdentifierTypeSyntax(name: "MockVerify"))
			}
		) {
			makeVerifyStorageProperty(protocolDecl: protocolDecl)
			makeCallContainerProperty()
			makeTimesStorageProperty()
			makeInit(protocolDecl: protocolDecl)
			for member in protocolDecl.memberBlock.members {
				if let funcDecl = member.decl.as(FunctionDeclSyntax.self) {
					try makeVerifyMethod(protocolDecl: protocolDecl, funcDecl: funcDecl)
				} else if let variableDecl = member.decl.as(VariableDeclSyntax.self) {
					for decl in try makeVerifyProperty(protocolDecl: protocolDecl, variableDecl: variableDecl) {
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
	
	private static func makeCallContainerProperty() -> VariableDeclSyntax {
		do {
			return try VariableDeclSyntax("let container: CallContainer")
		} catch {
			fatalError()
		}
		
//		VariableDeclSyntax(
//			.let,
//			name: "container",
//			type: TypeAnnotationSyntax(
//				type: IdentifierTypeSyntax(name: .identifier("CallContainer"))
//			)
//		)
	}
	
	private static func makeInit(protocolDecl: ProtocolDeclSyntax) -> InitializerDeclSyntax {
		InitializerDeclSyntax(
			modifiers: DeclModifierListSyntax {
				if protocolDecl.isPublic { .public }
			},
			signature: FunctionSignatureSyntax(
				parameterClause: FunctionParameterClauseSyntax {
					"mock: \(raw: protocolDecl.name.text)Mock"
					"container: CallContainer"
					"times: @escaping TimesMatcher"
				}
			),
			bodyBuilder: {
				"self.mock = mock"
				"self.container = container"
				"self.times = times"
			}
		)
	}
	
	// MARK: - Vertify Method for Method
	
	private static func makeVerifyMethod(protocolDecl: ProtocolDeclSyntax, funcDecl: FunctionDeclSyntax) throws -> FunctionDeclSyntax {
		let funcSignatureString = try makeFunctionSignatureString(funcDecl: funcDecl)
		return funcDecl
			.with(\.modifiers, DeclModifierListSyntax {
				if protocolDecl.isPublic { .public }
			})
			.with(\.signature, FunctionSignatureSyntax(
				parameterClause: wrapToArgumentMatcher(funcDecl.signature.parameterClause),
				returnClause: ReturnClauseSyntax(type: IdentifierTypeSyntax(name: .identifier("Void")))
			))
			.with(\.body, makeVerifyBody(
				arguments: funcDecl.signature.parameterClause.parameters.map { $0.secondName ?? $0.firstName },
				mockTypeToken: makeMockTypeToken(protocolDecl),
				funcSignatureExpr: ExprSyntax(literal: funcSignatureString)
			))
	}
	
	private static func makeCallStorageProperyName(funcDecl: FunctionDeclSyntax) -> TokenSyntax {
		TokenSyntax.identifier(makeInvocationContainerName(from: funcDecl).text + "___call")
	}
	
	// MARK: - Verify Method For Property
	
	private static func makeVerifyProperty(protocolDecl: ProtocolDeclSyntax, variableDecl: VariableDeclSyntax) throws -> [DeclSyntax] {
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
				let funcSignatureString = try makePropertySignatureString(bindingSyntax: bindingSyntax, accessorDecl: accessorDecl)
				let decl = DeclSyntax(
					fromProtocol: FunctionDeclSyntax(
						modifiers: DeclModifierListSyntax {
							if protocolDecl.isPublic { .public }
						},
						name: makeVerifyPropertyToken(bindingSyntax: bindingSyntax, accessorDecl: accessorDecl),
						signature: makeVerifyPropertyFunctionSignature(bindingSyntax: bindingSyntax, accessorDecl: accessorDecl),
						body: makeVerifyBody(
							arguments: makeArgumentList(accessorDecl: accessorDecl),
							mockTypeToken: makeMockTypeToken(protocolDecl),
							funcSignatureExpr: ExprSyntax(literal: funcSignatureString)
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
		mockTypeToken: TokenSyntax,
		funcSignatureExpr: ExprSyntax
	) -> CodeBlockSyntax {
		return CodeBlockSyntax {
			for stmt in makeArgumentMatcherZipStmts(tokens: arguments) {
				stmt
			}
			FunctionCallExprSyntax(
				calledExpression: ExprSyntax(stringLiteral: "container.verify"),
				leftParen: .leftParenToken(),
				rightParen: .rightParenToken()
			) {
				LabeledExprSyntax(
					label: "mock",
					expression: ExprSyntax(stringLiteral: "mock")
				)
				LabeledExprSyntax(
					label: "matcher",
					expression: ExprSyntax(stringLiteral: "argumentMatcher0")
				)
				LabeledExprSyntax(
					label: "times",
					expression: ExprSyntax(stringLiteral: "times")
				)
				LabeledExprSyntax(
					label: "type",
					expression: StringLiteralExprSyntax(content: mockTypeToken.text)
				)
				LabeledExprSyntax(
					label: "function",
					expression: funcSignatureExpr
				)
			}
		}
	}
	
	// MARK: - Integration to other files
	
	static func makeVerifyCallStorageProperty(
		isPublic: Bool
	) throws -> VariableDeclSyntax {
		var text = "let container = VerifyContainer()"
		if isPublic {
			text = TokenSyntax.keyword(.public).text + " " + text
		}
		return try VariableDeclSyntax("\(raw: text)")
	}
	
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
	
	static func makeStoreCallToStorageExpr(funcDecl: FunctionDeclSyntax) throws -> ExprSyntax {
		let functionSignature = try makeFunctionSignatureString(funcDecl: funcDecl)
		return "container.append(mock: self, call: MethodCall(arguments: arguments), function: \"\(raw: functionSignature)\")"
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
	
	static func makeStoreCallToStorageExpr(bindingSyntax: PatternBindingSyntax, accessorDecl: AccessorDeclSyntax) throws -> ExprSyntax {
		let propertySignatureString = try makePropertySignatureString(bindingSyntax: bindingSyntax, accessorDecl: accessorDecl)
		return "container.append(mock: self, call: MethodCall(arguments: arguments), function: \"\(raw: propertySignatureString)\")"
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
