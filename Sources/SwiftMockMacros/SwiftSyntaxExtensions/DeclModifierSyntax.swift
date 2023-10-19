//
//  DeclModifierSyntax.swift
//
//
//  Created by Alexandr Zalutskiy on 19/10/2023.
//

import SwiftSyntax

extension DeclModifierSyntax {
	static var `public`: DeclModifierSyntax {
		DeclModifierSyntax(name: TokenSyntax.keyword(.public))
	}
	
	var isPublic: Bool {
		name.isPublic
	}
}
