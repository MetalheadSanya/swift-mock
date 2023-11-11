//
//  DiagnosticMessage.swift
//
//
//  Created by Alexandr Zalutskiy on 17/10/2023.
//

import SwiftDiagnostics

struct DiagnosticError: Error {
	let diagnostic: Diagnostic
}

enum DiagnosticMessage: String, SwiftDiagnostics.DiagnosticMessage {
	case notAProtocol
	case `private`
	case filePrivate
	// TODO: #12 support for method attributes
	case attributesIsNotSupported
	case inheritanceIsNotSupported
	
	// TODO: support for generic where clause
	case genericWhereClauseIsNotSupported
	// TODO: support for reasync
	case reasyncIsNotSupported
	
	// Associated types
	// TODO: #38 Support for initializer in associated types
	case associatedTypeInitializerIsNotSupported
	
	case propertyAccessorsNotSpecified
	case propertyAccessorMustBeGetOrSet
	// TODO: support for get async in properties
	case asyncPropertiesIsNotSupported
	// TODO: support for get throws in properties
	case throwsPropertiesIsNotSupported
	
	case unknownEffectSpecifierInPropertyDeclaration
	
	case subscriptAccessorMustBeGetOrSet
	
	var severity: DiagnosticSeverity {
		switch self {
		case .notAProtocol:
			return .error
		case .private:
			return .error
		case .filePrivate:
			return .error
		case .attributesIsNotSupported:
			return .error
		case .inheritanceIsNotSupported:
			return .error
			
		case .genericWhereClauseIsNotSupported:
			return .error
		case .reasyncIsNotSupported:
			return .error
		
		// Associated types
		case .associatedTypeInitializerIsNotSupported:
			return .error
			
		case .propertyAccessorsNotSpecified:
			return .error
		case .propertyAccessorMustBeGetOrSet:
			return .error
		case .asyncPropertiesIsNotSupported:
			return .error
		case .throwsPropertiesIsNotSupported:
			return .error
		case .unknownEffectSpecifierInPropertyDeclaration:
			return .error
			
		case .subscriptAccessorMustBeGetOrSet:
			return .error
		}
	}
	
	var message: String {
		switch self {
		case .notAProtocol:
			return "'@Mock' can only be applied to a 'protocol'"
		case .private:
			return "'@Mock' cannot be applied to a 'private protocol'"
		case .filePrivate:
			return "'@Mock' cannot be applied to a 'fileprivate protocol'"
		case .attributesIsNotSupported:
			return "'@Mock' doesn't support method attributes"
		case .inheritanceIsNotSupported:
			return "'@Mock' can only be applied to a non-inherited 'protocol'"
			
		case .genericWhereClauseIsNotSupported:
			return "'@Mock' doesn't support generic where clause"
		case .reasyncIsNotSupported:
			return "'@Mock' doesn't support reasync methods"
			
		case .associatedTypeInitializerIsNotSupported:
			return "'@Mock' doesn't support initializer in associatedtypes"
			
		case .propertyAccessorsNotSpecified:
			return "Property in protocol must have explicit { get } or { get set } specifier"
		case .propertyAccessorMustBeGetOrSet:
			return "Expected get or set in a protocol property"
			
		case .asyncPropertiesIsNotSupported:
			return "'@Mock' doesn't support async properties"
		case .throwsPropertiesIsNotSupported:
			return "'@Mock' doesn't support throws properties"
		case .unknownEffectSpecifierInPropertyDeclaration:
			return "'@Mock' found unknown effect specifier in property declaration, please report in issue in GitHub"
			
		case .subscriptAccessorMustBeGetOrSet:
			return "Subscript in protocol must have explicit { get } or { get set } specifier"
		}
	}
	
	var diagnosticID: MessageID {
		MessageID(domain: "SwiftMockMacros", id: rawValue)
	}
}
