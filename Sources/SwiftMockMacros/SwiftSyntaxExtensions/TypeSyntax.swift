//
//  TypeSyntax.swift
//
//
//  Created by Alexandr Zalutskiy on 18/10/2023.
//

import SwiftSyntax

extension TypeSyntax {
	static var anyObject: IdentifierTypeSyntax {
		IdentifierTypeSyntax(name: .anyObject)
	}
	
	static var mock: IdentifierTypeSyntax {
		IdentifierTypeSyntax(name: .mock)
	}
	
	var isAnyObject: Bool {
		guard let self = self.as(IdentifierTypeSyntax.self) else {
			return false
		}
		return self.name.isAnyObject
	}
	
	var isMock: Bool {
		guard let self = self.as(IdentifierTypeSyntax.self) else {
			return false
		}
		return self.name.isMock
	}
	
	var text: String {
		String(trimmed.syntaxTextBytes.map { Unicode.Scalar($0) }.map { Character($0) })
	}
}
