//
//  FunctionDeclSyntax.swift
//
//
//  Created by Alexandr Zalutskiy on 19/10/2023.
//

import SwiftSyntax

extension FunctionDeclSyntax {
	var isAsync: Bool {
		signature.isAsync
	}
	
	var isThrows: Bool {
		signature.isThrows
	}
	
	var isRethrows: Bool {
		signature.isRethrows
	}
}
