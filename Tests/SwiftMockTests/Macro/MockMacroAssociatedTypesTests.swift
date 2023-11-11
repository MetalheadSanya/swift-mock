//
//  MockMacroAssociatedTypesTests.swift
//
//
//  Created by Alexandr Zalutskiy on 28/10/2023.
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

final class MockMacroAssociatedTypesTests: XCTestCase {
	func testAssociatedType() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			protocol Test {
				associatedtype A
			}
			""",
			expandedSource:
			"""
			protocol Test {
				associatedtype A
			}
			
			final class TestMock<A>: Test , Verifiable {
				struct Verify: MockVerify {
					let mock: TestMock
					let container: CallContainer
					let times: TimesMatcher
					init(mock: TestMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
				}
				let container = VerifyContainer()
			}
			""",
			macros: testMacros,
			indentationWidth: .tab
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}
	
	func testTwoAssociatedTypes() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			protocol Test {
				associatedtype A
				associatedtype B
			}
			""",
			expandedSource:
			"""
			protocol Test {
				associatedtype A
				associatedtype B
			}
			
			final class TestMock<A, B>: Test , Verifiable {
				struct Verify: MockVerify {
					let mock: TestMock
					let container: CallContainer
					let times: TimesMatcher
					init(mock: TestMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
				}
				let container = VerifyContainer()
			}
			""",
			macros: testMacros,
			indentationWidth: .tab
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}
	
	func testAssociatedTypeWithInheritedClause() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			protocol Test {
				associatedtype A: Encodable
			}
			""",
			expandedSource:
			"""
			protocol Test {
				associatedtype A: Encodable
			}
			
			final class TestMock<A: Encodable>: Test , Verifiable {
				struct Verify: MockVerify {
					let mock: TestMock
					let container: CallContainer
					let times: TimesMatcher
					init(mock: TestMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
				}
				let container = VerifyContainer()
			}
			""",
			macros: testMacros,
			indentationWidth: .tab
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}
	
	func testAssociatedTypeWithInheritedClauseWithTwoTypes() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			protocol Test {
				associatedtype A: Decodable, Encodable
			}
			""",
			expandedSource:
			"""
			protocol Test {
				associatedtype A: Decodable, Encodable
			}
			
			final class TestMock<A: Decodable & Encodable>: Test , Verifiable {
				struct Verify: MockVerify {
					let mock: TestMock
					let container: CallContainer
					let times: TimesMatcher
					init(mock: TestMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
				}
				let container = VerifyContainer()
			}
			""",
			macros: testMacros,
			indentationWidth: .tab
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}
	
	func testPrimaryAssociatedType() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			protocol Test<A> {
				associatedtype A: Encodable
			}
			""",
			expandedSource:
			"""
			protocol Test<A> {
				associatedtype A: Encodable
			}
			
			final class TestMock<A: Encodable>: Test, Verifiable {
				struct Verify: MockVerify {
					let mock: TestMock
					let container: CallContainer
					let times: TimesMatcher
					init(mock: TestMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
				}
				let container = VerifyContainer()
			}
			""",
			macros: testMacros,
			indentationWidth: .tab
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}
	
	func testTwoPrimaryAssociatedType() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			protocol Test<A, B> {
				associatedtype A: Decodable, Encodable
				associatedtype B
			}
			""",
			expandedSource:
			"""
			protocol Test<A, B> {
				associatedtype A: Decodable, Encodable
				associatedtype B
			}
			
			final class TestMock<A: Decodable & Encodable, B>: Test, Verifiable {
				struct Verify: MockVerify {
					let mock: TestMock
					let container: CallContainer
					let times: TimesMatcher
					init(mock: TestMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
				}
				let container = VerifyContainer()
			}
			""",
			macros: testMacros,
			indentationWidth: .tab
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}
}
