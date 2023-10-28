//
//  InheritanceClauseSyntax.swift
//
//
//  Created by Alexandr Zalutskiy on 28/10/2023.
//

import SwiftSyntax

extension InheritanceClauseSyntax {
	func toTypeSyntax() -> TypeSyntax {
		if let inheritedType = inheritedTypes.first, inheritedTypes.first == inheritedTypes.last {
			return inheritedType.type
		}
		
		return TypeSyntax(
			CompositionTypeSyntax(
				elements: CompositionTypeElementListSyntax {
					for inheritedType in inheritedTypes {
						CompositionTypeElementSyntax(
							type: inheritedType.type,
							ampersand: inheritedType == inheritedTypes.last ? nil : .binaryOperator("&")
						)
					}
				}
			)
		)
	}
}
