//
//  ProtocolDeclSyntax.swift
//
//
//  Created by Alexandr Zalutskiy on 19/10/2023.
//

import SwiftSyntax

extension ProtocolDeclSyntax {
	var isPublic: Bool {
		modifiers.contains(where: \.isPublic)
	}
}
