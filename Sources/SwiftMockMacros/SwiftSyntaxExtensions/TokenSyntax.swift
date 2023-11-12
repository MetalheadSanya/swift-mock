//
//  TokenSyntax.swift
//
//
//  Created by Alexandr Zalutskiy on 19/10/2023.
//

import SwiftSyntax

extension TokenSyntax {
	static var anyObject: TokenSyntax {
		.identifier("AnyObject")
	}
	
	static var mock: TokenSyntax {
		.identifier("Mock")
	}
	
	static var nsObject: TokenSyntax {
		.identifier("NSObject")
	}
	
	var isPublic: Bool {
		trimmed.text == TokenSyntax.keyword(.public).text
	}
	
	var isReasync: Bool {
		trimmed.text == TokenSyntax.keyword(.reasync).text
	}
	
	var isThrows: Bool {
		trimmed.text == TokenSyntax.keyword(.throws).text
	}
	
	var isRethrows: Bool {
		trimmed.text == TokenSyntax.keyword(.rethrows).text
	}
	
	var isGet: Bool {
		trimmed.text == TokenSyntax.keyword(.get).text
	}
	
	var isSet: Bool {
		trimmed.text == TokenSyntax.keyword(.set).text
	}
	
	var isSome: Bool {
		trimmed.text == TokenSyntax.keyword(.some).text
	}
	
	var isAnyObject: Bool {
		trimmed.text == "AnyObject"
	}
	
	var isMock: Bool {
		trimmed.text == "Mock"
	}
}
