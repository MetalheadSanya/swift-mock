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
	// FIXME: add support for internal protocols
	case notAPublicProtocol
	// TODO: #12 support for method attributes
	case attributesIsNotSupported
	// TODO: #32 Support for subscript
	case dynamicMemberLookupIsNotSupported
	// TODO: support primary associated types
	case primaryAssociatedTypesIsNotSupported
	case inheritanceIsNotSupported
	
	// TODO: support for generic where clause
	case genericWhereClauseIsNotSupported
	// TODO: support for rethrows
	case rethrowsIsNotSupported
	// TODO: support for reasync
	case reasyncIsNotSupported
	
	// TODO: support for associated types
	case associatedtypeIsNotSupported
	
	case propertyAccessorsNotSpecified
	case propertyAccessorMustBeGetOrSet
	// TODO: support for get async in properties
	case asyncPropertiesIsNotSupported
	// TODO: support for get throws in properties
	case throwsPropertiesIsNotSupported
	
	case unknownEffectSpecifierInPropertyDeclaration
	
	var severity: DiagnosticSeverity {
		switch self {
		case .notAProtocol:
			return .error
		case .private:
			return .error
		case .filePrivate:
			return .error
		case .notAPublicProtocol:
			return .error
		case .attributesIsNotSupported:
			return .error
		case .dynamicMemberLookupIsNotSupported:
			return .error
		case .primaryAssociatedTypesIsNotSupported:
			return .error
		case .inheritanceIsNotSupported:
			return .error
			
		case .genericWhereClauseIsNotSupported:
			return .error
		case .rethrowsIsNotSupported:
			return .error
		case .reasyncIsNotSupported:
			return .error
			
		case .associatedtypeIsNotSupported:
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
		case .notAPublicProtocol:
			return "'@Mock' can only be applied to a 'public protocol'"
		case .attributesIsNotSupported:
			return "'@Mock' doesn't support method attributes"
		case .dynamicMemberLookupIsNotSupported:
			return "'@Mock' doesn't support '@dynamicMemberLookup' attribute"
		case .primaryAssociatedTypesIsNotSupported:
			return "'@Mock' cannot be applied to a 'protocol' with primary associated types"
		case .inheritanceIsNotSupported:
			return "'@Mock' can only be applied to a non-inherited 'protocol'"
			
		case .genericWhereClauseIsNotSupported:
			return "'@Mock' doesn't support generic where clause"
		case .rethrowsIsNotSupported:
			return "'@Mock' doesn't support rethrows methods"
		case .reasyncIsNotSupported:
			return "'@Mock' doesn't support reasync methods"
			
		case .associatedtypeIsNotSupported:
			return "'@Mock' doesn't support associatedtypes"
			
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
		}
	}
	
	var diagnosticID: MessageID {
		MessageID(domain: "SwiftMockMacros", id: rawValue)
	}
}
