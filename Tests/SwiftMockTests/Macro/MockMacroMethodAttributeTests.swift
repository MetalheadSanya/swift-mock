//
//  MockMacroMethodAttributeTests.swift
//
//
//  Created by Alexandr Zalutskiy on 01/11/2023.
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

final class MockMacroMethodAttributeTests: XCTestCase {
	func testAvailableMethodAttribute() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			protocol Test {
				@available(iOS, introduced: 15.1)
				func test()
			}
			""",
			expandedSource:
			"""
			protocol Test {
				@available(iOS, introduced: 15.1)
				func test()
			}
			
			final class TestMock: Test , Verifiable {
				struct Verify: MockVerify {
					let mock: TestMock
					let container: CallContainer
					let times: TimesMatcher
					init(mock: TestMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
						@available(iOS, introduced: 15.1)
						func test() -> Void {
						let argumentMatcher0: ArgumentMatcher<()> = any()
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "test()")
					}
				}
				let container = VerifyContainer()
				private let test__ = MethodInvocationContainer()
					@available(iOS, introduced: 15.1)
					func $test() -> MethodSignature<(), Void> {
					let argumentMatcher0: ArgumentMatcher<()> = any()
					return MethodSignature<(), Void>(argumentMatcher: argumentMatcher0, register: {
							self.test__.append($0)
						})
				}
					@available(iOS, introduced: 15.1)
					func test() {
					let arguments = ()
					container.append(mock: self, call: MethodCall(arguments: arguments), function: "test()")
					return test__.find(with: arguments, type: "TestMock", function: "test()")
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
	
	func testDiscardableResultMethodAttribute() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			protocol Test {
				@discardableResult
				func test()
			}
			""",
			expandedSource:
			"""
			protocol Test {
				@discardableResult
				func test()
			}
			
			final class TestMock: Test , Verifiable {
				struct Verify: MockVerify {
					let mock: TestMock
					let container: CallContainer
					let times: TimesMatcher
					init(mock: TestMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
						func test() -> Void {
						let argumentMatcher0: ArgumentMatcher<()> = any()
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "test()")
					}
				}
				let container = VerifyContainer()
				private let test__ = MethodInvocationContainer()
					func $test() -> MethodSignature<(), Void> {
					let argumentMatcher0: ArgumentMatcher<()> = any()
					return MethodSignature<(), Void>(argumentMatcher: argumentMatcher0, register: {
							self.test__.append($0)
						})
				}
					@discardableResult
					func test() {
					let arguments = ()
					container.append(mock: self, call: MethodCall(arguments: arguments), function: "test()")
					return test__.find(with: arguments, type: "TestMock", function: "test()")
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
	
	func testInlinableMethodAttribute() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			protocol Test {
				@inlinable
				func test()
			}
			""",
			expandedSource:
			"""
			protocol Test {
				@inlinable
				func test()
			}
			
			final class TestMock: Test , Verifiable {
				struct Verify: MockVerify {
					let mock: TestMock
					let container: CallContainer
					let times: TimesMatcher
					init(mock: TestMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
						func test() -> Void {
						let argumentMatcher0: ArgumentMatcher<()> = any()
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "test()")
					}
				}
				let container = VerifyContainer()
				private let test__ = MethodInvocationContainer()
					func $test() -> MethodSignature<(), Void> {
					let argumentMatcher0: ArgumentMatcher<()> = any()
					return MethodSignature<(), Void>(argumentMatcher: argumentMatcher0, register: {
							self.test__.append($0)
						})
				}
					@inlinable
					func test() {
					let arguments = ()
					container.append(mock: self, call: MethodCall(arguments: arguments), function: "test()")
					return test__.find(with: arguments, type: "TestMock", function: "test()")
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
	
	func testObjcMethodAttribute() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			protocol Test {
				@objc
				func test()
			}
			""",
			expandedSource:
			"""
			protocol Test {
				@objc
				func test()
			}
			
			final class TestMock: Test , Verifiable {
				struct Verify: MockVerify {
					let mock: TestMock
					let container: CallContainer
					let times: TimesMatcher
					init(mock: TestMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
						func test() -> Void {
						let argumentMatcher0: ArgumentMatcher<()> = any()
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "test()")
					}
				}
				let container = VerifyContainer()
				private let test__ = MethodInvocationContainer()
					func $test() -> MethodSignature<(), Void> {
					let argumentMatcher0: ArgumentMatcher<()> = any()
					return MethodSignature<(), Void>(argumentMatcher: argumentMatcher0, register: {
							self.test__.append($0)
						})
				}
					@objc
					func test() {
					let arguments = ()
					container.append(mock: self, call: MethodCall(arguments: arguments), function: "test()")
					return test__.find(with: arguments, type: "TestMock", function: "test()")
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
