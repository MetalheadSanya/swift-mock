//
//  AssociatedType.swift
//
//
//  Created by Alexandr Zalutskiy on 28/10/2023.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder

enum AssociatedTypePrecessor {
	static func makeGenericParameterClause(
		associatedTypeDecls: [AssociatedTypeDeclSyntax]
	) throws -> GenericParameterClauseSyntax? {
		try associatedTypeDecls.forEach(validate(associatedTypeDecl:))
		
		guard !associatedTypeDecls.isEmpty else {
			return nil
		}
		return GenericParameterClauseSyntax {
			for associatedTypeDecl in associatedTypeDecls {
				GenericParameterSyntax(
					name: associatedTypeDecl.name,
					colon: associatedTypeDecl.inheritanceClause.map { _ in TokenSyntax.colonToken() },
					inheritedType: associatedTypeDecl.inheritanceClause?.toTypeSyntax()
				)
			}
		}
	}
	
	private static func validate(associatedTypeDecl: AssociatedTypeDeclSyntax) throws {
		// TODO: #37 Support for generic where clause in associated types
		if let genericWhereClause = associatedTypeDecl.genericWhereClause {
			let diagnostic = Diagnostic(node: genericWhereClause, message: DiagnosticMessage.genericWhereClauseIsNotSupported)
			throw DiagnosticError(diagnostic: diagnostic)
		}
		// TODO: #38 Support for initializer in associated types
		if let initializer = associatedTypeDecl.initializer {
			let diagnostic = Diagnostic(node: initializer, message: DiagnosticMessage.associatedTypeInitializerIsNotSupported)
			throw DiagnosticError(diagnostic: diagnostic)
		}
	}
}
