import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(SwiftMockMacros)
import SwiftMockMacros

private let testMacros: [String: Macro.Type] = [
	"Mock": MockMacro.self,
]
#endif

final class MockMacroGenericMethodTests: XCTestCase {
	func testOneGenericParameter() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				func call<T>(_ argument: T)
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				func call<T>(_ argument: T)
			}
			
			public final class TestMock: Test , Verifiable {
				public struct Verify: MockVerify {
					let mock: TestMock
					let container: CallContainer
					let times: TimesMatcher
					public init(mock: TestMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
					public
						func call<T>(_ argument: @escaping ArgumentMatcher<T> = any(), file: StaticString = #filePath, line: UInt = #line) -> Void {
						let argumentMatcher0 = argument
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "call<T>(_:)", file: file, line: line)
					}
				}
				public init() {
				}
				public let container = VerifyContainer()
				private let call___ = MethodInvocationContainer()
				public
					func $call<T>(_ argument: @escaping ArgumentMatcher<T> = any()) -> MethodSignature<(T), Void> {
					let argumentMatcher0 = argument
					return MethodSignature<(T), Void>(argumentMatcher: argumentMatcher0, register: {
							self.call___.append($0)
						})
				}
				public func call<T>(_ argument: T) {
					let arguments = (argument)
					container.append(mock: self, call: MethodCall(arguments: arguments), function: "call<T>(_:)")
					return call___.find(with: arguments, type: "TestMock", function: "call<T>(_:)")
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
	
	func testGenericReturn() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				func call<T>(_ argument: T) -> T
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				func call<T>(_ argument: T) -> T
			}
			
			public final class TestMock: Test , Verifiable {
				public struct Verify: MockVerify {
					let mock: TestMock
					let container: CallContainer
					let times: TimesMatcher
					public init(mock: TestMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
					public
						func call<T>(_ argument: @escaping ArgumentMatcher<T> = any(), file: StaticString = #filePath, line: UInt = #line) -> Void {
						let argumentMatcher0 = argument
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "call<T>(_:) -> T", file: file, line: line)
					}
				}
				public init() {
				}
				public let container = VerifyContainer()
				private let call___ = MethodInvocationContainer()
				public
					func $call<T>(_ argument: @escaping ArgumentMatcher<T> = any()) -> MethodSignature<(T), T> {
					let argumentMatcher0 = argument
					return MethodSignature<(T), T>(argumentMatcher: argumentMatcher0, register: {
							self.call___.append($0)
						})
				}
				public func call<T>(_ argument: T) -> T {
					let arguments = (argument)
					container.append(mock: self, call: MethodCall(arguments: arguments), function: "call<T>(_:) -> T")
					return call___.find(with: arguments, type: "TestMock", function: "call<T>(_:) -> T")
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
	
	func testInheritedType() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				func call<T: Equitable & Hashable>(_ argument: T) -> T
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				func call<T: Equitable & Hashable>(_ argument: T) -> T
			}
			
			public final class TestMock: Test , Verifiable {
				public struct Verify: MockVerify {
					let mock: TestMock
					let container: CallContainer
					let times: TimesMatcher
					public init(mock: TestMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
					public
						func call<T: Equitable & Hashable>(_ argument: @escaping ArgumentMatcher<T> = any(), file: StaticString = #filePath, line: UInt = #line) -> Void {
						let argumentMatcher0 = argument
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "call<T: Equitable & Hashable>(_:) -> T", file: file, line: line)
					}
				}
				public init() {
				}
				public let container = VerifyContainer()
				private let call___ = MethodInvocationContainer()
				public
					func $call<T: Equitable & Hashable>(_ argument: @escaping ArgumentMatcher<T> = any()) -> MethodSignature<(T), T> {
					let argumentMatcher0 = argument
					return MethodSignature<(T), T>(argumentMatcher: argumentMatcher0, register: {
							self.call___.append($0)
						})
				}
				public func call<T: Equitable & Hashable>(_ argument: T) -> T {
					let arguments = (argument)
					container.append(mock: self, call: MethodCall(arguments: arguments), function: "call<T: Equitable & Hashable>(_:) -> T")
					return call___.find(with: arguments, type: "TestMock", function: "call<T: Equitable & Hashable>(_:) -> T")
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
	
	func testAsyncThrows() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				func call<T: Equitable & Hashable>(_ argument: T) async throws -> T
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				func call<T: Equitable & Hashable>(_ argument: T) async throws -> T
			}
			
			public final class TestMock: Test , Verifiable {
				public struct Verify: MockVerify {
					let mock: TestMock
					let container: CallContainer
					let times: TimesMatcher
					public init(mock: TestMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
					public
						func call<T: Equitable & Hashable>(_ argument: @escaping ArgumentMatcher<T> = any(), file: StaticString = #filePath, line: UInt = #line) -> Void {
						let argumentMatcher0 = argument
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "call<T: Equitable & Hashable>(_:) async throws -> T", file: file, line: line)
					}
				}
				public init() {
				}
				public let container = VerifyContainer()
				private let call___asyncthrows = AsyncThrowsMethodInvocationContainer()
				public
					func $call<T: Equitable & Hashable>(_ argument: @escaping ArgumentMatcher<T> = any()) -> AsyncThrowsMethodSignature<(T), T> {
					let argumentMatcher0 = argument
					return AsyncThrowsMethodSignature<(T), T>(argumentMatcher: argumentMatcher0, register: {
							self.call___asyncthrows.append($0)
						})
				}
				public func call<T: Equitable & Hashable>(_ argument: T) async throws -> T {
					let arguments = (argument)
					container.append(mock: self, call: MethodCall(arguments: arguments), function: "call<T: Equitable & Hashable>(_:) async throws -> T")
					return try await call___asyncthrows.find(with: arguments, type: "TestMock", function: "call<T: Equitable & Hashable>(_:) async throws -> T")
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
