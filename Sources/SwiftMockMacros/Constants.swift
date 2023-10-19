import SwiftSyntax
import SwiftSyntaxBuilder

let voidType: TypeSyntax = TypeSyntax(
	fromProtocol: IdentifierTypeSyntax(name: .identifier("Void"))
)

let emptyArrayExpt = ExprSyntax(
	fromProtocol: ArrayExprSyntax(expressions: [])
)

let privateModifier = DeclModifierSyntax(name: .keyword(.private))
let fileprivateModifier = DeclModifierSyntax(name: .keyword(.fileprivate))
let internalModifier = DeclModifierSyntax(name: .keyword(.internal))

let finalModifier = DeclModifierSyntax(name: .keyword(.final))

let anyFunctionCallExpr = ExprSyntax(
	fromProtocol: FunctionCallExprSyntax(
		calledExpression: DeclReferenceExprSyntax(
			baseName: .identifier("any")
		),
		leftParen: .leftParenToken(),
		rightParen: .rightParenToken()
	) { }
)

let escapingAttribute = AttributeListSyntax.Element.attribute(
	AttributeSyntax(
		attributeName: IdentifierTypeSyntax(
			name: .identifier("escaping")
		)
	)
)

