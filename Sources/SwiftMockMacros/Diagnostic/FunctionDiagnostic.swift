//
//  FunctionDiagnostic.swift
//  
//
//  Created by Alexandr Zalutskiy on 18/10/2023.
//

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax

extension Diagnostic {
	static func validateFunctionDecl(_ declaration: FunctionDeclSyntax) throws {
		if let effectSpecifiers = declaration.signature.effectSpecifiers {
			if let asyncSpecifier = effectSpecifiers.asyncSpecifier, asyncSpecifier.isReasync {
				let diagnostic = Diagnostic(node: asyncSpecifier, message: DiagnosticMessage.reasyncIsNotSupported)
				throw DiagnosticError(diagnostic: diagnostic)
			}
			
			if let throwsSpecifier = effectSpecifiers.throwsSpecifier, throwsSpecifier.isRethrows {
				let diagnostic = Diagnostic(node: throwsSpecifier, message: DiagnosticMessage.rethrowsIsNotSupported)
				throw DiagnosticError(diagnostic: diagnostic)
			}
		}
		
		if let genericWhereClause = declaration.genericWhereClause {
			let diagnostic = Diagnostic(node: genericWhereClause, message: DiagnosticMessage.genericWhereClauseIsNotSupported)
			throw DiagnosticError(diagnostic: diagnostic)
		}
	}
}
