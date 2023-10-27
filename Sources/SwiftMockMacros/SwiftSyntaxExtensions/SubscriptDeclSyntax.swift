//
//  SubscriptDeclSyntax.swift
//
//
//  Created by Alexandr Zalutskiy on 20/10/2023.
//

import Foundation
import SwiftSyntax

extension SubscriptDeclSyntax {
	func makeInvocationContainerBaseNameToken() -> TokenSyntax {
		var subscriptDecl = self
		subscriptDecl.accessorBlock = nil
		
		let escaping = [
			" ",
			"<",
			">",
			":",
			"-",
			"&",
			"@",
			"(",
			")",
			",",
		]
		
		var literal = String(subscriptDecl.trimmed.syntaxTextBytes.map { Unicode.Scalar($0) }.map { Character($0) })
			
		for escape in escaping {
			literal = literal.replacingOccurrences(of: escape, with: "_")
		}
		
		return TokenSyntax.identifier(literal)
	}
}
