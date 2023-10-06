import SwiftSyntax
import SwiftSyntaxBuilder

let voidType: TypeSyntax = TypeSyntax(
	fromProtocol: IdentifierTypeSyntax(name: .identifier("Void"))
)

let emptyArrayExpt = ExprSyntax(
	fromProtocol: ArrayExprSyntax(expressions: [])
)

let publicModifier = DeclModifierSyntax(name: .keyword(.public))
let privateModifier = DeclModifierSyntax(name: .keyword(.private))
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

