//
//  MethodProcessor.swift
//
//
//  Created by Alexandr Zalutskiy on 01/11/2023.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder

enum MethodProcessor {
	static func makeVerifyMethodAttributes(functionDecl: FunctionDeclSyntax) -> AttributeListSyntax {
		guard functionDecl.attributes.contains(where: \.isAvailable) else { return [] }
		return functionDecl.attributes.filter(\.isAvailable)
	}
	
	static func makeSignatureMethodAttributes(functionDecl: FunctionDeclSyntax) -> AttributeListSyntax {
		guard functionDecl.attributes.contains(where: \.isAvailable) else { return [] }
		return functionDecl.attributes.filter(\.isAvailable)
	}
	
	static func makeMockMethodArrtibutes(functionDecl: FunctionDeclSyntax) -> AttributeListSyntax {
		return functionDecl.attributes
	}
}
