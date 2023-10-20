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
	
	static var nsObject: IdentifierTypeSyntax {
		IdentifierTypeSyntax(name: .nsObject)
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
	
	var isDynamicMemberLookup: Bool {
		guard let self = self.as(IdentifierTypeSyntax.self) else {
			return false
		}
		return self.name.trimmed.text == "dynamicMemberLookup"
	}
	
	var isObjc: Bool {
		guard let self = self.as(IdentifierTypeSyntax.self) else {
			return false
		}
		return self.name.trimmed.text == TokenSyntax.keyword(.objc).text
	}
	
	var text: String {
		String(trimmed.syntaxTextBytes.map { Unicode.Scalar($0) }.map { Character($0) })
	}
}
