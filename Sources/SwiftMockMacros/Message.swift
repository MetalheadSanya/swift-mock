//
//  Message.swift
//
//
//  Created by Alexandr Zalutskiy on 15/10/2023.
//

import SwiftSyntax
import SwiftSyntaxBuilder

enum MessageError: Error {
	case message(String)
}

extension MockMacro {
	static func makeFunctionSignatureString(funcDecl: FunctionDeclSyntax) throws -> String {
		var literal = ""
		literal += funcDecl.name.text
		if let genericParameterClause = funcDecl.genericParameterClause {
			literal += "<"
			literal += genericParameterClause.parameters.map(\.text).joined(separator: ",")
			literal += ">"
		}
		literal += "("
		for parameter in funcDecl.signature.parameterClause.parameters {
			literal += parameter.firstName.text
			literal += ":"
		}
		literal += ")"
		if let asyncSpecifier = funcDecl.signature.effectSpecifiers?.asyncSpecifier {
			literal += " " + asyncSpecifier.text
		}
		if let throwsSpecifier = funcDecl.signature.effectSpecifiers?.throwsSpecifier {
			literal += " " + throwsSpecifier.text
		}
		if let returnClause = funcDecl.signature.returnClause {
			literal += " -> "
			let type = String(returnClause.type.trimmed.syntaxTextBytes.map { Unicode.Scalar($0) }.map { Character($0) })
			literal += type
		}
		return literal
	}
	
	static func makePropertySignatureString(
		bindingSyntax: PatternBindingSyntax,
		accessorDecl: AccessorDeclSyntax
	) throws -> String {
		guard let text = bindingSyntax.pattern.as(IdentifierPatternSyntax.self)?.identifier.text else {
			throw MessageError.message("For property supported only decloration using IdentifierPatternSyntax")
		}
		var literal = ""
		literal += text
		if accessorDecl.accessorSpecifier.trimmed.text == TokenSyntax.keyword(.set).text {
			literal += "="
		}
		if let asyncSpecifier = accessorDecl.effectSpecifiers?.asyncSpecifier {
			literal += " " + asyncSpecifier.text
		}
		if let throwsSpecifier = accessorDecl.effectSpecifiers?.throwsSpecifier {
			literal += " " + throwsSpecifier.text
		}
		return literal
	}
	
	static func makeSubscriptSignatureString(
		subscriptDecl: SubscriptDeclSyntax
	) -> String {
		String(subscriptDecl.trimmed.syntaxTextBytes.map { Unicode.Scalar($0) }.map { Character($0) })
	}
}
