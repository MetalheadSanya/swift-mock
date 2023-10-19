//
//  PropertyDiagnostic.swift
//
//
//  Created by Alexandr Zalutskiy on 19/10/2023.
//

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax

extension Diagnostic {
	static func validatePropertyDeclaration(_ declaration: VariableDeclSyntax) throws {
		for binding in declaration.bindings {
			// Protocols must contains accessor block by language design
			guard let accessorBlock = binding.accessorBlock else {
				let diagnostic = Diagnostic(node: declaration, message: DiagnosticMessage.propertyAccessorsNotSpecified)
				throw DiagnosticError(diagnostic: diagnostic)
			}
			// Protocols must contains accessor block by language design
			guard case let .`accessors`(accessorList) = accessorBlock.accessors else {
				let diagnostic = Diagnostic(
					node: declaration,
					message: DiagnosticMessage.propertyAccessorsNotSpecified
				)
				throw DiagnosticError(diagnostic: diagnostic)
			}
			
			for accessorDecl in accessorList {
				let accessorSpecifier = accessorDecl.accessorSpecifier
				guard accessorSpecifier.isGet || accessorSpecifier.isSet else {
					let diagnostic = Diagnostic(node: accessorSpecifier, message: DiagnosticMessage.propertyAccessorMustBeGetOrSet)
					throw DiagnosticError(diagnostic: diagnostic)
				}
				
				if let effectSpecifiers = accessorDecl.effectSpecifiers {
					if let asyncSpecifier = effectSpecifiers.asyncSpecifier {
						let diagnostic = Diagnostic(node: asyncSpecifier, message: DiagnosticMessage.asyncPropertiesIsNotSupported)
						throw DiagnosticError(diagnostic: diagnostic)
					}
				}
			}
		}
	}
}
