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
		literal += "("
		for parameter in funcDecl.signature.parameterClause.parameters {
			literal += parameter.firstName.text
			literal += ":"
		}
		literal += ")"
		if funcDecl.signature.effectSpecifiers?.asyncSpecifier != nil {
			literal += " async"
		}
		if funcDecl.signature.effectSpecifiers?.throwsSpecifier != nil {
			literal += " throws"
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
		return literal
	}
}
