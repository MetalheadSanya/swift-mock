//
//  MockMacroDiagnosticTests.swift
//
//
//  Created by Alexandr Zalutskiy on 18/10/2023.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(SwiftMockMacros)
import SwiftMockMacros

private let testMacros: [String: Macro.Type] = [
	"Mock": MockMacro.self,
]
#endif

final class MockMacroDiagnosticTests: XCTestCase {
	func testNotAProtocolDiagnostic() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public class Test { }
			""",
			expandedSource:
			"""
			public class Test { }
			""",
			diagnostics: [
				DiagnosticSpec(message: "'@Mock' can only be applied to a 'protocol'", line: 1, column: 1)
			],
			macros: testMacros,
			indentationWidth: .tab
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}
	
	func testPrivateProtocolDiagnostic() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			private protocol Test { }
			""",
			expandedSource:
			"""
			private protocol Test { }
			""",
			diagnostics: [
				DiagnosticSpec(message: "'@Mock' cannot be applied to a 'private protocol'", line: 2, column: 1)
			],
			macros: testMacros,
			indentationWidth: .tab
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}
	
	func testFilePrivateProtocolDiagnostic() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			fileprivate protocol Test { }
			""",
			expandedSource:
			"""
			fileprivate protocol Test { }
			""",
			diagnostics: [
				DiagnosticSpec(message: "'@Mock' cannot be applied to a 'fileprivate protocol'", line: 2, column: 1)
			],
			macros: testMacros,
			indentationWidth: .tab
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}
	
	func testInheritedProtocolDiagnostic() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test: Equitable { }
			""",
			expandedSource:
			"""
			public protocol Test: Equitable { }
			""",
			diagnostics: [
				DiagnosticSpec(message: "'@Mock' can only be applied to a non-inherited 'protocol'", line: 2, column: 21)
			],
			macros: testMacros,
			indentationWidth: .tab
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}
	
	func testMethodWithGenericParametersDiagnostic() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				func call<T>(_: T) where T: Equitable
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				func call<T>(_: T) where T: Equitable
			}
			""",
			diagnostics: [
				DiagnosticSpec(message: "'@Mock' doesn't support generic where clause", line: 3, column: 21)
			],
			macros: testMacros,
			indentationWidth: .tab
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}
	
	func testRethrowsMethod() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				func test(_ callback: () throws -> Void) rethrows
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				func test(_ callback: () throws -> Void) rethrows
			}
			""",
			diagnostics: [
				DiagnosticSpec(message: "'@Mock' doesn't support rethrows methods", line: 3, column: 43)
			],
			macros: testMacros,
			indentationWidth: .tab
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}
	
	func testReasyncMethod() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				func test(_ callback: () async -> Void) reasync
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				func test(_ callback: () async -> Void) reasync
			}
			""",
			diagnostics: [
				DiagnosticSpec(message: "'@Mock' doesn't support reasync methods", line: 3, column: 42)
			],
			macros: testMacros,
			indentationWidth: .tab
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}
	
	func testPropertyWithoutAccessorSpecifier() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				var test: Int
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				var test: Int
			}
			""",
			diagnostics: [
				DiagnosticSpec(message: "Property in protocol must have explicit { get } or { get set } specifier", line: 3, column: 2)
			],
			macros: testMacros,
			indentationWidth: .tab
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}
	
	func testPropertyWithIncorrectAccessorSpecifier() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				var test: Int { didSet }
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				var test: Int { didSet }
			}
			""",
			diagnostics: [
				DiagnosticSpec(message: "Expected get or set in a protocol property", line: 3, column: 18)
			],
			macros: testMacros,
			indentationWidth: .tab
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}
	
	// TODO: #37 Support for generic where clause in associated types
	func testAssociatedTypeGenericWhereClause() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			protocol Test {
				associatedtype A: K where K.A == Self
			}
			""",
			expandedSource:
			"""
			protocol Test {
				associatedtype A: K where K.A == Self
			}
			""",
			diagnostics: [
				DiagnosticSpec(message: "'@Mock' doesn't support generic where clause", line: 3, column: 22)
			],
			macros: testMacros,
			indentationWidth: .tab
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}
	
	// TODO: #38 Support for initializer in associated types
	func testAssociatedTypeInitializer() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			protocol Test {
				associatedtype A = Int
			}
			""",
			expandedSource:
			"""
			protocol Test {
				associatedtype A = Int
			}
			""",
			diagnostics: [
				DiagnosticSpec(message: "'@Mock' doesn't support initializer in associatedtypes", line: 3, column: 19)
			],
			macros: testMacros,
			indentationWidth: .tab
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
	#endif
	}
}
