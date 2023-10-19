import SwiftSyntax
import SwiftSyntaxBuilder

extension MockMacro {
	
	static func makeVariableMock(
		from variableDecl: VariableDeclSyntax,
		mockTypeToken: TokenSyntax,
		isPublic: Bool
	) throws -> [DeclSyntax] {
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
				declarations.append(makeInvocationContainerProperty(patternBinding: bindingSyntax, accessorDecl: accessorDecl))
				declarations.append(makeSignatureMethod(patternBinding: bindingSyntax, accessorDecl: accessorDecl, isPublic: isPublic))
			}
			declarations.append(try makeMockProperty(bindingSyntax: bindingSyntax, mockTypeToken: mockTypeToken, isPublic: isPublic))
		}
		return declarations
	}
	
	// MARK: - Making the Method Invocation Container
	
	private static func makeInvocationContainerProperty(
		patternBinding: PatternBindingSyntax,
		accessorDecl: AccessorDeclSyntax
	) -> DeclSyntax {
		let bindings = makeInvocationContainerPatternBindingList(
			patternBinding: patternBinding,
			accessorDecl: accessorDecl
		)
		return DeclSyntax(
			fromProtocol: VariableDeclSyntax(
				modifiers: DeclModifierListSyntax {
					privateModifier
				},
				bindingSpecifier: .keyword(.var),
				bindings: bindings
			)
		)
	}
	
	private static func makeInvocationContainerPatternBindingList(
		patternBinding: PatternBindingSyntax,
		accessorDecl: AccessorDeclSyntax
	) -> PatternBindingListSyntax {
		switch accessorDecl.accessorSpecifier.trimmed.text {
		case TokenSyntax.keyword(.get).text:
			return PatternBindingListSyntax {
				makeGetterPatterBinding(
					bindingSyntax: patternBinding,
					accessorDecl: accessorDecl
				)
			}
		case TokenSyntax.keyword(.set).text:
			return PatternBindingListSyntax {
				makeSetterPatterBinding(from: patternBinding)
			}
		default:
			fatalError("Unexpected accessor for property. Supported accessors: \"get\" and \"set\"")
		}
	}
	
	private static func makeInvocationContainerInitializerClause() -> InitializerClauseSyntax {
		InitializerClauseSyntax(value: emptyArrayExpt)
	}
	
	// MARK: - Make Getter Invocation Container
	
	private static func makeGetterPatterBinding(
		bindingSyntax binding: PatternBindingSyntax,
		accessorDecl: AccessorDeclSyntax
	) -> PatternBindingSyntax {
		PatternBindingSyntax(
			pattern: makeGetterInvocationContainerPattern(from: binding),
			typeAnnotation: makeGetterInvocationContainerTypeAnnotation(
				bindingSyntax: binding,
				accessorDecl: accessorDecl
			),
			initializer: makeInvocationContainerInitializerClause()
		)
	}
	
	private static func makeGetterInvocationContainerPattern(
		from bindingSyntax: PatternBindingSyntax
	) -> PatternSyntax {
		let token = makeGetterInvocationContainerToken(from: bindingSyntax)
		return PatternSyntax(
			IdentifierPatternSyntax(identifier: token)
		)
	}
	
	static func makeGetterInvocationContainerToken(from bindingSyntax: PatternBindingSyntax) -> TokenSyntax {
		let propertyPattern = bindingSyntax.pattern.as(IdentifierPatternSyntax.self) ?? IdentifierPatternSyntax(identifier: .identifier("unknown"))
		return .identifier(propertyPattern.identifier.text + "___getter")
	}
	
	private static func makeGetterInvocationContainerTypeAnnotation(
		bindingSyntax: PatternBindingSyntax,
		accessorDecl: AccessorDeclSyntax
	) -> TypeAnnotationSyntax {
		TypeAnnotationSyntax(
			type: makeGetterInvocationContainerType(
				bindingSyntax: bindingSyntax,
				accessorDecl: accessorDecl
			)
		)
	}
	
	private static func makeGetterInvocationContainerType(
		bindingSyntax: PatternBindingSyntax,
		accessorDecl: AccessorDeclSyntax
	) -> TypeSyntax {
		let returnType = getBindingType(from: bindingSyntax)
		return TypeSyntax(
			fromProtocol: ArrayTypeSyntax(
				element: makeMethodInvocationType(
					isAsync: accessorDecl.isAsync,
					isThrows: accessorDecl.isThrows,
					returnType: returnType
				)
			)
		)
		
	}
	
	// MARK: - Make Setter Invocation Container
	
	private static func makeSetterPatterBinding(from binding: PatternBindingSyntax) -> PatternBindingSyntax {
		PatternBindingSyntax(
			pattern: makeSetterInvocationContainerPattern(from: binding),
			typeAnnotation: makeSetterInvocationContainerTypeAnnotation(from: binding),
			initializer: makeInvocationContainerInitializerClause()
		)
	}
	
	private static func makeSetterInvocationContainerPattern(from bindingSyntax: PatternBindingSyntax) -> PatternSyntax {
		let token = makeSetterInvocationContainerToken(from: bindingSyntax)
		return PatternSyntax(
			IdentifierPatternSyntax(identifier: token)
		)
	}
	
	static func makeSetterInvocationContainerToken(from bindingSyntax: PatternBindingSyntax) -> TokenSyntax {
		let propertyPattern = bindingSyntax.pattern.as(IdentifierPatternSyntax.self) ?? IdentifierPatternSyntax(identifier: .identifier("unknown"))
		return .identifier(propertyPattern.identifier.text + "___setter")
	}
	
	private static func makeSetterInvocationContainerTypeAnnotation(from bindingSyntax: PatternBindingSyntax) -> TypeAnnotationSyntax {
		TypeAnnotationSyntax(type: makeSetterInvocationContainerType(from: bindingSyntax))
	}
	
	private static func makeSetterInvocationContainerType(from bindingSyntax: PatternBindingSyntax) -> TypeSyntax {
		let returnType = getBindingType(from: bindingSyntax)
		return TypeSyntax(
			fromProtocol: ArrayTypeSyntax(
				element: makeMethodInvocationType(arguments: [returnType])
			)
		)
	}
	
	// MARK: - Making the Signature Method
	
	private static func makeSignatureMethod(
		patternBinding: PatternBindingSyntax,
		accessorDecl: AccessorDeclSyntax,
		isPublic: Bool
	) -> DeclSyntax {
		switch accessorDecl.accessorSpecifier.trimmed.text {
		case TokenSyntax.keyword(.get).text:
			return makeGetterSignatureMethod(
				patternBinding: patternBinding,
				accessorDecl: accessorDecl,
				isPublic: isPublic
			)
		case TokenSyntax.keyword(.set).text:
			return makeSetterSignatureMethod(from: patternBinding, isPublic: isPublic)
		default:
			fatalError("Unexpected accessor for property. Supported accessors: \"get\" and \"set\"")
		}
	}
	
	// MARK: - Making the Getter Signature Method
	
	static func makeGetterSignatureMethod(
		patternBinding: PatternBindingSyntax,
		accessorDecl: AccessorDeclSyntax,
		isPublic: Bool
	) -> DeclSyntax {
		let returnType = getBindingType(from: patternBinding)
		let containerToken = makeGetterInvocationContainerToken(from: patternBinding)
		return DeclSyntax(
			fromProtocol: FunctionDeclSyntax(
				modifiers: DeclModifierListSyntax {
					if isPublic { .public }
				},
				name: makeGetterSignatureMethodName(from: patternBinding),
				signature: FunctionSignatureSyntax(
					parameterClause: FunctionParameterClauseSyntax { },
					returnClause: makeGetterSignatureMethodReturnClause(
						bindingSyntax: patternBinding,
						accessorDecl: accessorDecl
					)
				)
			) {
				ReturnStmtSyntax(
					expression: FunctionCallExprSyntax(
						calledExpression: makeMethodSignatureExpr(
							isAsync: accessorDecl.isAsync,
							isThrows: accessorDecl.isThrows,
							returnType: returnType
						),
						leftParen: .leftParenToken(),
						rightParen: .rightParenToken()
					) {
						LabeledExprSyntax(
							label: "argumentMatcher",
							expression: anyFunctionCallExpr
						)
						makeMethodSignatureRegisterLabeledExpr(from: containerToken)
					}
				)
			}
		)
	}
	
	private static func makeGetterSignatureMethodName(from bindingSyntax: PatternBindingSyntax) -> TokenSyntax {
		// TODO: error of unknown type
		let propertyPattern = bindingSyntax.pattern.as(IdentifierPatternSyntax.self) ?? IdentifierPatternSyntax(identifier: .identifier("unknown"))
		return .identifier("$" + propertyPattern.identifier.text + "Getter")
	}
	
	private static func makeGetterSignatureMethodReturnClause(
		bindingSyntax: PatternBindingSyntax,
		accessorDecl: AccessorDeclSyntax
	) -> ReturnClauseSyntax {
		let returnType = getBindingType(from: bindingSyntax)
		return ReturnClauseSyntax(
			type: makeMethodSignatureType(
				isAsync: accessorDecl.isAsync,
				isThrows: accessorDecl.isThrows,
				returnType: returnType
			)
		)
	}
	
	// MARK: - Making the Setter Signature Method
	
	static func makeSetterSignatureMethod(
		from patternBinding: PatternBindingSyntax,
		isPublic: Bool
	) -> DeclSyntax {
		let returnType = getBindingType(from: patternBinding)
		let containerToken = makeSetterInvocationContainerToken(from: patternBinding)
		return DeclSyntax(
			fromProtocol: FunctionDeclSyntax(
				modifiers: DeclModifierListSyntax {
					if isPublic { .public }
				},
				name: makeSetterSignatureMethodName(from: patternBinding),
				signature: FunctionSignatureSyntax(
					parameterClause: FunctionParameterClauseSyntax {
						FunctionParameterSyntax(
							firstName: TokenSyntax.identifier("_"),
							secondName: TokenSyntax.identifier("value"),
							type: wrapToEscapingType(type: wrapToArgumentMatcherType(type: returnType)),
							defaultValue: InitializerClauseSyntax(value: anyFunctionCallExpr)
						)
					},
					returnClause: makeSetterSignatureMethodReturnClause(from: patternBinding)
				)
			) {
				for stmt in makeArgumentMatcherZipStmts(tokens: [.identifier("value")]) {
					stmt
				}
				ReturnStmtSyntax(
					expression: FunctionCallExprSyntax(
						calledExpression: makeMethodSignatureExpr(arguments: [returnType]),
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
	
	private static func makeSetterSignatureMethodName(from bindingSyntax: PatternBindingSyntax) -> TokenSyntax {
		// TODO: error of unknown type
		let propertyPattern = bindingSyntax.pattern.as(IdentifierPatternSyntax.self) ?? IdentifierPatternSyntax(identifier: .identifier("unknown"))
		return .identifier("$" + propertyPattern.identifier.text + "Setter")
	}
	
	private static func makeSetterSignatureMethodReturnClause(from bindingSyntax: PatternBindingSyntax) -> ReturnClauseSyntax {
		let returnType = getBindingType(from: bindingSyntax)
		return ReturnClauseSyntax(
			type: makeMethodSignatureType(arguments: [returnType])
		)
	}
	
	// MARK: - Making the Mock Property
	
	static func makeMockProperty(
		bindingSyntax: PatternBindingSyntax,
		mockTypeToken: TokenSyntax,
		isPublic: Bool
	) throws -> DeclSyntax {
		var isThrows = false
		var isAsync = false
		if let accessorBlock = bindingSyntax.accessorBlock {
			if case let .`accessors`(accessorList) = accessorBlock.accessors {
				for accessorDecl in accessorList {
					if accessorDecl.isThrows {
						isThrows = true
					}
					if accessorDecl.isAsync {
						isAsync = true
					}
				}
			}
		}
		let getAccessorDecl = AccessorDeclSyntax(
			accessorSpecifier: .keyword(.get),
			effectSpecifiers: AccessorEffectSpecifiersSyntax(
				asyncSpecifier: isAsync ? .keyword(.async) : nil,
				throwsSpecifier: isThrows ? .keyword(.throws) : nil
			)
		)
		let returnValue = try makeMockGetterReturnExpr(
			bindingSyntax: bindingSyntax,
			accessorDecl: getAccessorDecl,
			mockTypeToken: mockTypeToken
		)
		var accessorDeclListSyntax = try AccessorDeclListSyntax {
			try getAccessorDecl.with(\.body, CodeBlockSyntax {
				"let arguments = ()"
				try makeStoreCallToStorageExpr(bindingSyntax: bindingSyntax, accessorDecl: getAccessorDecl)
				if getAccessorDecl.isAsync && getAccessorDecl.isThrows {
					ReturnStmtSyntax(
						expression: TryExprSyntax(
							expression: AwaitExprSyntax(
								expression: returnValue
							)
						)
					)
				} else if getAccessorDecl.isAsync {
					ReturnStmtSyntax(
						expression: AwaitExprSyntax(
							expression: returnValue
						)
					)
				} else if getAccessorDecl.isThrows {
					ReturnStmtSyntax(
						expression: TryExprSyntax(
							expression: returnValue
						)
					)
				} else {
					ReturnStmtSyntax(
						expression: returnValue
					)
				}
			})
		}
		guard let accessorBlock = bindingSyntax.accessorBlock else {
			fatalError("Property MUST have accessor block in protocol declaration")
		}
		guard case let .`accessors`(accessors) = accessorBlock.accessors else {
			fatalError("Property MUST have accessor block in protocol declaration")
		}
		let hasSetter = accessors.reduce(false) {
			$0 || $1.accessorSpecifier.trimmed.text == TokenSyntax.keyword(.set).text
		}
		if hasSetter {
			accessorDeclListSyntax.append(
				try AccessorDeclSyntax(
					accessorSpecifier: .keyword(.set)
				) {
					"let arguments = (newValue)"
					try makeStoreCallToStorageExpr(bindingSyntax: bindingSyntax, accessorDecl: AccessorDeclSyntax(accessorSpecifier: .keyword(.set)))
					ReturnStmtSyntax(
						expression: try makeMockSetterReturnExpr(
							bindingSyntax: bindingSyntax,
							accessorDecl: AccessorDeclSyntax(accessorSpecifier: .keyword(.set)),
							mockTypeToken: mockTypeToken
						)
					)
				}
			)
		}
		return DeclSyntax(
			fromProtocol: VariableDeclSyntax(
				modifiers: DeclModifierListSyntax {
					if isPublic { .public }
				},
				bindingSpecifier: .keyword(.var),
				bindings: PatternBindingListSyntax {
					PatternBindingSyntax(
						pattern: bindingSyntax.pattern,
						typeAnnotation: bindingSyntax.typeAnnotation,
						accessorBlock: AccessorBlockSyntax(
							accessors: .accessors(
								accessorDeclListSyntax
							)
						)
					)
				}
			)
		)
	}
	
	private static func makeMockGetterReturnExpr(
		bindingSyntax: PatternBindingSyntax,
		accessorDecl: AccessorDeclSyntax,
		mockTypeToken: TokenSyntax
	) throws -> ExprSyntax {
		let invocationType = makeTokenWithPrefix(
			isAsync: accessorDecl.isAsync,
			isThrows: accessorDecl.isThrows,
			token: .identifier("MethodInvocation")
		)
		let propertySignatureString = try makePropertySignatureString(bindingSyntax: bindingSyntax, accessorDecl: accessorDecl)
		return ExprSyntax(
			fromProtocol: FunctionCallExprSyntax(
				calledExpression: MemberAccessExprSyntax(
					base: DeclReferenceExprSyntax(baseName: invocationType),
					declName: DeclReferenceExprSyntax(baseName: .identifier("find"))
				),
				leftParen: .leftParenToken(),
				rightParen: .rightParenToken()
			) {
				LabeledExprSyntax(
					label: "in",
					expression: DeclReferenceExprSyntax(baseName: makeGetterInvocationContainerToken(from: bindingSyntax))
				)
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
		bindingSyntax: PatternBindingSyntax,
		accessorDecl: AccessorDeclSyntax,
		mockTypeToken: TokenSyntax
	) throws -> ExprSyntax {
		let invocationType = TokenSyntax.identifier("MethodInvocation")
		let propertySignatureString = try makePropertySignatureString(bindingSyntax: bindingSyntax, accessorDecl: accessorDecl)
		return ExprSyntax(
			fromProtocol: FunctionCallExprSyntax(
				calledExpression: MemberAccessExprSyntax(
					base: DeclReferenceExprSyntax(baseName: invocationType),
					declName: DeclReferenceExprSyntax(baseName: .identifier("find"))
				),
				leftParen: .leftParenToken(),
				rightParen: .rightParenToken()
			) {
				LabeledExprSyntax(
					label: "in",
					expression: DeclReferenceExprSyntax(baseName: makeSetterInvocationContainerToken(from: bindingSyntax))
				)
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
	
	// MARK: - General functions
	
	static func getBindingType(from bindingSyntax: PatternBindingSyntax) -> TypeSyntax {
		// TODO: error of unknown type
		bindingSyntax.typeAnnotation?.type.trimmed ?? voidType
	}
}
