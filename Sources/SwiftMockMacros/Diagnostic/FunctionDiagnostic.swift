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
		if let attribute = declaration.attributes.first {
			let diagnostic = Diagnostic(node: attribute, message: DiagnosticMessage.attributesIsNotSupported)
			throw DiagnosticError(diagnostic: diagnostic)
		}
		
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
	}
}
