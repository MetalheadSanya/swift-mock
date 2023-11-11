//
//  FunctionSignatureSyntax.swift
//
//
//  Created by Alexandr Zalutskiy on 19/10/2023.
//

import SwiftSyntax

extension FunctionSignatureSyntax {
	var isAsync: Bool {
		effectSpecifiers?.asyncSpecifier != nil
	}
	
	var isThrows: Bool {
		guard let throwsSpecifier = effectSpecifiers?.throwsSpecifier, throwsSpecifier.isThrows else {
			return false
		}
		return true
	}
	
	var isRethrows: Bool {
		guard let throwsSpecifier = effectSpecifiers?.throwsSpecifier, throwsSpecifier.isRethrows else {
			return false
		}
		return true
	}
}
