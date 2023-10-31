//
//  MockMacroMethodTests.swift
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

final class MockMacroMethodTests: XCTestCase {
	func testEscapingMethod() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			protocol Test {
				func test(_ f: @escaping (Int) -> Void)
			}
			""",
			expandedSource:
			"""
			protocol Test {
				func test(_ f: @escaping (Int) -> Void)
			}
			
			final class TestMock: Test, Verifiable {
				struct Verify: MockVerify {
					let mock: TestMock
					let container: CallContainer
					let times: TimesMatcher
					init(mock: TestMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
						func test(_ f: @escaping ArgumentMatcher<(Int) -> Void> = any()) -> Void {
						let argumentMatcher0 = f
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "test(_:)")
					}
				}
				let container = VerifyContainer()
				private let test___ = MethodInvocationContainer()
					func $test(_ f: @escaping ArgumentMatcher<(Int) -> Void> = any()) -> MethodSignature<((Int) -> Void), Void> {
					let argumentMatcher0 = f
					return MethodSignature<((Int) -> Void), Void>(argumentMatcher: argumentMatcher0, register: {
							self.test___.append($0)
						})
				}
					func test(_ f: @escaping (Int) -> Void) {
					let arguments = (f)
					container.append(mock: self, call: MethodCall(arguments: arguments), function: "test(_:)")
					return test___.find(with: arguments, type: "TestMock", function: "test(_:)")
				}
			}
			""",
			macros: testMacros,
			indentationWidth: .tab
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}
	
	func testNonEscapingMethod() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			protocol Test {
				func test(_ f: (Int) -> Void)
			}
			""",
			expandedSource:
			"""
			protocol Test {
				func test(_ f: (Int) -> Void)
			}
			
			final class TestMock: Test, Verifiable {
				struct Verify: MockVerify {
					let mock: TestMock
					let container: CallContainer
					let times: TimesMatcher
					init(mock: TestMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
						func test(_ f: @escaping ArgumentMatcher<NonEscapingFunction> = any()) -> Void {
						let argumentMatcher0 = f
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "test(_:)")
					}
				}
				let container = VerifyContainer()
				private let test___ = MethodInvocationContainer()
					func $test(_ f: @escaping ArgumentMatcher<NonEscapingFunction> = any()) -> MethodSignature<(NonEscapingFunction), Void> {
					let argumentMatcher0 = f
					return MethodSignature<(NonEscapingFunction), Void>(argumentMatcher: argumentMatcher0, register: {
							self.test___.append($0)
						})
				}
					func test(_ f: (Int) -> Void) {
					let arguments = (NonEscapingFunction())
					container.append(mock: self, call: MethodCall(arguments: arguments), function: "test(_:)")
					return test___.find(with: arguments, type: "TestMock", function: "test(_:)")
				}
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
