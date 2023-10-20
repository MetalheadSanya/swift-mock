//
//  GenericParameterSyntax.swift
//
//
//  Created by Alexandr Zalutskiy on 20/10/2023.
//

import SwiftSyntax

extension GenericParameterSyntax {
	var text: String {
		String(trimmed.syntaxTextBytes.map { Unicode.Scalar($0) }.map { Character($0) })
	}
}
