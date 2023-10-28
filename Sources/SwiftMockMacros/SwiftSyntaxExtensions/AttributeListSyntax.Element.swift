//
//  AttributeListSyntax.Element.swift
//
//
//  Created by Alexandr Zalutskiy on 20/10/2023.
//

import SwiftSyntax

extension AttributeListSyntax.Element {
	var isMock: Bool {
		guard case let .attribute(attributeSyntax) = self else {
			return false
		}
		return attributeSyntax.attributeName.isMock
	}
	
	var isDynamicMemberLookup: Bool {
		guard case let .attribute(attributeSyntax) = self else {
			return false
		}
		return attributeSyntax.attributeName.isDynamicMemberLookup
	}
	
	var isObjc: Bool {
		guard case let .attribute(attributeSyntax) = self else {
			return false
		}
		return attributeSyntax.attributeName.isObjc
	}
	
	var isEscaping: Bool {
		guard case let .attribute(attributeSyntax) = self else {
			return false
		}
		return attributeSyntax.attributeName.isEscaping
	}
}
