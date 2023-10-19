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
		effectSpecifiers?.throwsSpecifier != nil
	}
}
