//
//  ProtocolDiagnostic.swift
//
//
//  Created by Alexandr Zalutskiy on 18/10/2023.
//

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax

extension Diagnostic {
	static func extractProtocolDecl(_ declaration: some DeclSyntaxProtocol) throws -> ProtocolDeclSyntax {
		guard let declaration = declaration.as(ProtocolDeclSyntax.self) else {
			let diagnostic = Diagnostic(node: declaration, message: DiagnosticMessage.notAProtocol)
			throw DiagnosticError(diagnostic: diagnostic)
		}
		
		return declaration
	}
	
	static func validateProtocolDecl(_ declaration: ProtocolDeclSyntax) throws {
		if let modifier = declaration.modifiers.first(where: { $0.name.text == privateModifier.name.text }) {
			let diagnostic = Diagnostic(node: modifier, message: DiagnosticMessage.private)
			throw DiagnosticError(diagnostic: diagnostic)
		}
		if let modifier = declaration.modifiers.first(where: { $0.name.text == fileprivateModifier.name.text }) {
			let diagnostic = Diagnostic(node: modifier, message: DiagnosticMessage.filePrivate)
			throw DiagnosticError(diagnostic: diagnostic)
		}
		
		if let inheritanceClause = declaration.inheritanceClause, inheritanceClause.inheritedTypes.contains(where: { !$0.type.isAnyObject }) {
			let diagnostic = Diagnostic(node: inheritanceClause, message: DiagnosticMessage.inheritanceIsNotSupported)
			throw DiagnosticError(diagnostic: diagnostic)
		}
		
		for member in declaration.memberBlock.members {
			if let functionDecl = member.decl.as(FunctionDeclSyntax.self) {
				try Diagnostic.validateFunctionDecl(functionDecl)
			} else if let variableDeclaration = member.decl.as(VariableDeclSyntax.self) {
				try Diagnostic.validatePropertyDeclaration(variableDeclaration)
			}
		}
	}
}
