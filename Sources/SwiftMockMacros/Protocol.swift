//
//  Protocol.swift
//
//
//  Created by Alexandr Zalutskiy on 20/10/2023.
//

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension MockMacro {
	static func makeMockDeclAttributes(protocolDecl: ProtocolDeclSyntax) -> AttributeListSyntax {
		let mockDeclarationAttributes = protocolDecl.attributes
			.filter { !$0.isMock }
			.map(makeMockDeclAttribute)
		
		return AttributeListSyntax {
			for mockDeclarationAttribute in mockDeclarationAttributes {
				mockDeclarationAttribute
			}
		}
	}
	
	private static func makeMockDeclAttribute(attributeListSyntaxElement: AttributeListSyntax.Element) -> AttributeListSyntax.Element {
		guard case let .attribute(attributeSyntax) = attributeListSyntaxElement else {
			return attributeListSyntaxElement
		}
		if attributeSyntax.attributeName.isObjc {
			return .attribute("@objc")
		}
		return attributeListSyntaxElement
	}
}
