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
						func test(_ f: @escaping ArgumentMatcher<(Int) -> Void> = any(), file: StaticString = #filePath, line: UInt = #line) -> Void {
						let argumentMatcher0 = f
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "test(_:)", file: file, line: line)
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
						func test(_ f: @escaping ArgumentMatcher<NonEscapingFunction> = any(), file: StaticString = #filePath, line: UInt = #line) -> Void {
						let argumentMatcher0 = f
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "test(_:)", file: file, line: line)
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
	
	func testRethrowsMethod() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			protocol Test {
				func test(_ f: @escaping (Int) throws -> Void) rethrows
			}
			""",
			expandedSource:
			"""
			protocol Test {
				func test(_ f: @escaping (Int) throws -> Void) rethrows
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
						func test(_ f: @escaping ArgumentMatcher<(Int) throws -> Void> = any(), file: StaticString = #filePath, line: UInt = #line) -> Void {
						let argumentMatcher0 = f
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "test(_:) rethrows", file: file, line: line)
					}
				}
				let container = VerifyContainer()
				private let test___rethrows = RethrowsMethodInvocationContainer()
					func $test(_ f: @escaping ArgumentMatcher<(Int) throws -> Void> = any()) -> RethrowsMethodSignature<((Int) throws -> Void), Void> {
					let argumentMatcher0 = f
					return RethrowsMethodSignature<((Int) throws -> Void), Void>(argumentMatcher: argumentMatcher0, register: {
							self.test___rethrows.append($0)
						})
				}
				func test(_ f: @escaping (Int) throws -> Void) rethrows {
					let arguments = (f)
					container.append(mock: self, call: MethodCall(arguments: arguments), function: "test(_:) rethrows")
					return try test___rethrows.find(with: arguments, type: "TestMock", function: "test(_:) rethrows", {
							throw $0
						})
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
	
	func testAsyncRethrowsMethod() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			protocol Test {
				func test(_ f: @escaping (Int) throws -> Void) async rethrows
			}
			""",
			expandedSource:
			"""
			protocol Test {
				func test(_ f: @escaping (Int) throws -> Void) async rethrows
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
						func test(_ f: @escaping ArgumentMatcher<(Int) throws -> Void> = any(), file: StaticString = #filePath, line: UInt = #line) -> Void {
						let argumentMatcher0 = f
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "test(_:) async rethrows", file: file, line: line)
					}
				}
				let container = VerifyContainer()
				private let test___asyncrethrows = AsyncRethrowsMethodInvocationContainer()
					func $test(_ f: @escaping ArgumentMatcher<(Int) throws -> Void> = any()) -> AsyncRethrowsMethodSignature<((Int) throws -> Void), Void> {
					let argumentMatcher0 = f
					return AsyncRethrowsMethodSignature<((Int) throws -> Void), Void>(argumentMatcher: argumentMatcher0, register: {
							self.test___asyncrethrows.append($0)
						})
				}
				func test(_ f: @escaping (Int) throws -> Void) async rethrows {
					let arguments = (f)
					container.append(mock: self, call: MethodCall(arguments: arguments), function: "test(_:) async rethrows")
					return try await test___asyncrethrows.find(with: arguments, type: "TestMock", function: "test(_:) async rethrows", {
							throw $0
						})
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
	
	func testMethodWithAnyArgument() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			protocol Test {
				func test(_ f: any Equatable)
			}
			""",
			expandedSource:
			"""
			protocol Test {
				func test(_ f: any Equatable)
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
						func test(_ f: @escaping ArgumentMatcher<any Equatable> = any(), file: StaticString = #filePath, line: UInt = #line) -> Void {
						let argumentMatcher0 = f
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "test(_:)", file: file, line: line)
					}
				}
				let container = VerifyContainer()
				private let test___ = MethodInvocationContainer()
					func $test(_ f: @escaping ArgumentMatcher<any Equatable> = any()) -> MethodSignature<(any Equatable), Void> {
					let argumentMatcher0 = f
					return MethodSignature<(any Equatable), Void>(argumentMatcher: argumentMatcher0, register: {
							self.test___.append($0)
						})
				}
				func test(_ f: any Equatable) {
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
	
	func testMethodWithSomeArgument() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			protocol Test {
				func test(_ f: some Equatable)
			}
			""",
			expandedSource:
			"""
			protocol Test {
				func test(_ f: some Equatable)
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
						func test(_ f: @escaping ArgumentMatcher<any Equatable> = any(), file: StaticString = #filePath, line: UInt = #line) -> Void {
						let argumentMatcher0 = f
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "test(_:)", file: file, line: line)
					}
				}
				let container = VerifyContainer()
				private let test___ = MethodInvocationContainer()
					func $test(_ f: @escaping ArgumentMatcher<any Equatable> = any()) -> MethodSignature<(any Equatable), Void> {
					let argumentMatcher0 = f
					return MethodSignature<(any Equatable), Void>(argumentMatcher: argumentMatcher0, register: {
							self.test___.append($0)
						})
				}
				func test(_ f: some Equatable) {
					let arguments = (f as any Equatable)
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
