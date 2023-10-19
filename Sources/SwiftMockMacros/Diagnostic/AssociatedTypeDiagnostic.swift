//
//  AssociatedTypeDiagnostic.swift
//  
//
//  Created by Alexandr Zalutskiy on 19/10/2023.
//

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax

extension Diagnostic {
	static func validateAssociatedTypeDecl(_ declaration: AssociatedTypeDeclSyntax) throws {
		let diagnostic = Diagnostic(node: declaration, message: DiagnosticMessage.associatedtypeIsNotSupported)
		throw DiagnosticError(diagnostic: diagnostic)
	}
}

