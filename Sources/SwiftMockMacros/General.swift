import SwiftSyntax
import SwiftSyntaxBuilder

extension MockMacro {
	// MARK: - Making Method Wrapper Types
	
	static func makeMethodSignatureType(
		isAsync: Bool = false,
		isThrows: Bool = false,
		isRethrows: Bool = false,
		arguments: [TypeSyntax] = [],
		returnType: TypeSyntax? = nil
	) -> TypeSyntax {
		makeMethodWrapperType(
			baseName: .identifier("MethodSignature"),
			isAsync: isAsync,
			isThrows: isThrows,
			isRethrows: isRethrows,
			arguments: arguments,
			returnType: returnType
		)
	}
	
	private static func makeMethodWrapperType(
		baseName: TokenSyntax,
		isAsync: Bool,
		isThrows: Bool,
		isRethrows: Bool,
		arguments: [TypeSyntax],
		returnType: TypeSyntax?
	) -> TypeSyntax {
		let type = makeTokenWithPrefix(isAsync: isAsync, isThrows: isThrows, isRethrows: isRethrows, token: baseName)
		return TypeSyntax(
			IdentifierTypeSyntax(
				name: type,
				genericArgumentClause: makeTupleGenericArgumentClause(arguments: arguments, returnType: returnType)
			)
		)
	}
	
	static func makeMethodSignatureExpr(
		isAsync: Bool = false,
		isThrows: Bool = false,
		isRethrows: Bool = false,
		arguments: [TypeSyntax] = [],
		returnType: TypeSyntax? = nil
	) -> ExprSyntax {
		makeMethodWrappperExpr(
			baseName: "MethodSignature",
			isAsync: isAsync,
			isThrows: isThrows,
			isRethrows: isRethrows,
			arguments: arguments,
			returnType: returnType
		)
	}
	
	private static func makeMethodWrappperExpr(
		baseName: TokenSyntax,
		isAsync: Bool,
		isThrows: Bool,
		isRethrows: Bool,
		arguments: [TypeSyntax],
		returnType: TypeSyntax?
	) -> ExprSyntax {
		let type = makeTokenWithPrefix(isAsync: isAsync, isThrows: isThrows, isRethrows: isRethrows, token: baseName)
		return ExprSyntax(
			fromProtocol: GenericSpecializationExprSyntax(
				expression: DeclReferenceExprSyntax(baseName: type),
				genericArgumentClause: makeTupleGenericArgumentClause(arguments: arguments, returnType: returnType)
			)
		)
	}
	
	static func makeTokenWithPrefix(
		isAsync: Bool,
		isThrows: Bool,
		isRethrows: Bool,
		token: TokenSyntax
	) -> TokenSyntax {
		var name = token.text
		if isThrows {
			name = "Throws" + name
		}
		if isRethrows {
			name = "Rethrows" + name
		}
		if isAsync {
			name = "Async" + name
		}
		
		return TokenSyntax.identifier(name)
	}
	
	private static func makeTupleGenericArgumentClause<T: Collection>(
		arguments: T,
		returnType: TypeSyntax?
	) -> GenericArgumentClauseSyntax where T.Element == TypeSyntax {
		GenericArgumentClauseSyntax {
			packTypesToGenericArgumentSyntax(types: arguments)
			GenericArgumentSyntax(
				argument: returnType ?? voidType
			)
		}
	}
	
	static func packTypesToGenericArgumentSyntax<T: Collection>(
		types: T
	) -> GenericArgumentSyntax where T.Element == TypeSyntax {
		GenericArgumentSyntax(
			argument: makeTupleType(from: types)
		)
	}
	
	private static func makeTupleType<T: Collection>(
		from types: T
	) -> TypeSyntax where T.Element == TypeSyntax {
		return TypeSyntax(
			fromProtocol: TupleTypeSyntax(
				elements: packParametersToTupleType(types)
			)
		)
	}
	
	private static func packParametersToTupleType<Z: Collection>(
		_ types: Z
	) -> TupleTypeElementListSyntax where Z.Element == TypeSyntax {
		if types.count <= 1 {
			return TupleTypeElementListSyntax {
				for type in types {
					TupleTypeElementSyntax(type: makeParameterTypeReadyForPacking(type: type))
				}
			}
		} else {
			let rest = types.dropFirst()
			return  TupleTypeElementListSyntax {
				TupleTypeElementSyntax(type: makeParameterTypeReadyForPacking(type: types.first!))
				TupleTypeElementSyntax(
					type: TupleTypeSyntax(elements: packParametersToTupleType(rest))
				)
			}
		}
	}
	
	private static func makeParameterTypeReadyForPacking(type: some TypeSyntaxProtocol) -> TypeSyntax {
		// Check on escaping attribute, if exist, remove then pack
		if let type = type.as(AttributedTypeSyntax.self),
			 type.attributes.contains(where: { $0.isEscaping }) {
			if type.attributes.count == 1 {
				return TypeSyntax(
					type.baseType
				)
			} else {
				return TypeSyntax(
					AttributedTypeSyntax(
						attributes: type.attributes.filter { !$0.isEscaping },
						baseType: type.baseType
					)
				)
			}
		}
		
		if let type = type.as(SomeOrAnyTypeSyntax.self) {
			return TypeSyntax(
					SomeOrAnyTypeSyntax(
						someOrAnySpecifier: TokenSyntax.keyword(.any),
						constraint: type.constraint
					)
			)
		}
		
		// Check on nonescaping func, if non-escaping, use NonEscapingFunction
		if type.as(FunctionTypeSyntax.self) != nil {
			return TypeSyntax(
				IdentifierTypeSyntax(name: .identifier("NonEscapingFunction"))
			)
		}
		// Some other type
		return TypeSyntax(type)
	}
	
	// MARK: - Making Labeled Expressions
	
	static func makeMethodSignatureRegisterLabeledExpr(from containerToken: TokenSyntax) -> LabeledExprSyntax {
		LabeledExprSyntax(
			label: "register",
			expression: ClosureExprSyntax {
				FunctionCallExprSyntax(
					calledExpression: MemberAccessExprSyntax(
						base: MemberAccessExprSyntax(
							base: DeclReferenceExprSyntax(baseName: TokenSyntax.keyword(.`self`)),
							declName: DeclReferenceExprSyntax(baseName: containerToken)
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
	
	// MARK: - MethodInvocationContainer
	
	private static func makeMethodInvocationContainerType(
		isAsync: Bool,
		isThrows: Bool,
		isRethrows: Bool
	) -> TypeSyntax {
		let token = makeTokenWithPrefix(
			isAsync: isAsync,
			isThrows: isThrows,
			isRethrows: isRethrows,
			token: .identifier("MethodInvocationContainer")
		)
		return TypeSyntax(
			IdentifierTypeSyntax(name: token)
		)
	}
	
	private static func makeMethodInvocationContainerTypeExpr(
		isAsync: Bool,
		isThrows: Bool,
		isRethrows: Bool
	) -> TypeExprSyntax {
		TypeExprSyntax(
			type: makeMethodInvocationContainerType(
				isAsync: isAsync,
				isThrows: isThrows,
				isRethrows: isRethrows
			)
		)
	}
	
	static func makeMethodInvocationContainerInitializerClause(
		isAsync: Bool,
		isThrows: Bool,
		isRethrows: Bool
	) -> InitializerClauseSyntax {
		InitializerClauseSyntax(
			value: FunctionCallExprSyntax(
				calledExpression: makeMethodInvocationContainerTypeExpr(
					isAsync: isAsync,
					isThrows: isThrows,
					isRethrows: isRethrows
				),
				leftParen: .leftParenToken(),
				rightParen: .rightParenToken()
			) { }
		)
	}
	
	// MARK: - ArgumentMatcher
	
	static func wrapToEscapingType(type: TypeSyntax) -> TypeSyntax {
		TypeSyntax(
			fromProtocol: AttributedTypeSyntax(
				attributes: AttributeListSyntax {
					escapingAttribute
				},
				baseType: type
			)
		)
	}
	
	static func wrapToArgumentMatcherType(type: TypeSyntax) -> TypeSyntax {
		TypeSyntax(
			fromProtocol: IdentifierTypeSyntax(
				name: "ArgumentMatcher",
				genericArgumentClause: GenericArgumentClauseSyntax {
					GenericArgumentSyntax(argument: makeParameterTypeReadyForPacking(type: type))
				}
			)
		)
	}
	
	static func makeArgumentMatcherZipStmts(tokens: [TokenSyntax]) -> [DeclSyntax] {
		var stmts: [DeclSyntax] = []
		if tokens.isEmpty {
			stmts.append("let argumentMatcher0: ArgumentMatcher<()> = any()")
		} else {
			for (index, token) in tokens.enumerated().reversed() {
				if index == tokens.count - 1 {
					stmts.append("let argumentMatcher\(raw: index) = \(raw: token.text)")
				} else {
					stmts.append("let argumentMatcher\(raw: index) = zip(\(raw: token.text), argumentMatcher\(raw: index + 1))")
				}
			}
		}
		return stmts
	}
}
