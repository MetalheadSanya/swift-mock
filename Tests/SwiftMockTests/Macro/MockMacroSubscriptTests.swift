import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(SwiftMockMacros)
import SwiftMockMacros

private let testMacros: [String: Macro.Type] = [
	"Mock": MockMacro.self,
]
#endif

final class MockMacroSubscriptTests: XCTestCase {
	func testGet() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				subscript(_ value: Int) -> Int { get }
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				subscript(_ value: Int) -> Int { get }
			}
			
			public final class TestMock: Test, Verifiable {
				public struct Verify: MockVerify {
					let mock: TestMock
					let container: CallContainer
					let times: TimesMatcher
					public init(mock: TestMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
					public func subscriptGetter(_ value: @escaping ArgumentMatcher<Int> = any()) {
						let argumentMatcher0 = value
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "subscript(_ value: Int) -> Int { get }")
					}
				}
				public let container = VerifyContainer()
				private let subscript___value__Int_____Int___getter = MethodInvocationContainer()
				public func $subscriptGetter(_ value: @escaping ArgumentMatcher<Int> = any()) -> MethodSignature<(Int), Int> {
					let argumentMatcher0 = value
					return MethodSignature<(Int), Int>(argumentMatcher: argumentMatcher0, register: {
							self.subscript___value__Int_____Int___getter.append($0)
						})
				}
				public
					subscript(_ value: Int) -> Int {
					get {
						let arguments = (value)
						container.append(mock: self, call: MethodCall(arguments: arguments), function: "subscript(_ value: Int) -> Int { get }")
						return subscript___value__Int_____Int___getter.find(with: arguments, type: "TestMock", function: "subscript(_ value: Int) -> Int { get }")
					}
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
	
	func testGetSet() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				subscript(_ value: Int) -> Int { get set }
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				subscript(_ value: Int) -> Int { get set }
			}
			
			public final class TestMock: Test, Verifiable {
				public struct Verify: MockVerify {
					let mock: TestMock
					let container: CallContainer
					let times: TimesMatcher
					public init(mock: TestMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
					public func subscriptGetter(_ value: @escaping ArgumentMatcher<Int> = any()) {
						let argumentMatcher0 = value
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "subscript(_ value: Int) -> Int { get set }")
					}
					public func subscriptSetter(_ value: @escaping ArgumentMatcher<Int> = any(), newValue: @escaping ArgumentMatcher<Int> = any()) {
						let argumentMatcher1 = newValue
						let argumentMatcher0 = zip(value, argumentMatcher1)
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "subscript(_ value: Int) -> Int { get set }")
					}
				}
				public let container = VerifyContainer()
				private let subscript___value__Int_____Int___getter = MethodInvocationContainer()
				public func $subscriptGetter(_ value: @escaping ArgumentMatcher<Int> = any()) -> MethodSignature<(Int), Int> {
					let argumentMatcher0 = value
					return MethodSignature<(Int), Int>(argumentMatcher: argumentMatcher0, register: {
							self.subscript___value__Int_____Int___getter.append($0)
						})
				}
				private let subscript___value__Int_____Int___setter = MethodInvocationContainer()
				public func $subscriptSetter(_ value: @escaping ArgumentMatcher<Int> = any(), newValue: @escaping ArgumentMatcher<Int> = any()) -> MethodSignature<(Int, (Int)), Void> {
					let argumentMatcher1 = newValue
					let argumentMatcher0 = zip(value, argumentMatcher1)
					return MethodSignature<(Int, (Int)), Void>(argumentMatcher: argumentMatcher0, register: {
							self.subscript___value__Int_____Int___setter.append($0)
						})
				}
				public
					subscript(_ value: Int) -> Int {
					get {
						let arguments = (value)
						container.append(mock: self, call: MethodCall(arguments: arguments), function: "subscript(_ value: Int) -> Int { get set }")
						return subscript___value__Int_____Int___getter.find(with: arguments, type: "TestMock", function: "subscript(_ value: Int) -> Int { get set }")
					}
					set {
						let arguments = (value, (newValue))
						container.append(mock: self, call: MethodCall(arguments: arguments), function: "subscript(_ value: Int) -> Int { get set }")
						return subscript___value__Int_____Int___setter.find(with: arguments, type: "TestMock", function: "subscript(_ value: Int) -> Int { get set }")
					}
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
	
	func testGetSetGeneric() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				subscript<T: Equitable>(_ value: T) -> T { get set }
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				subscript<T: Equitable>(_ value: T) -> T { get set }
			}
			
			public final class TestMock: Test, Verifiable {
				public struct Verify: MockVerify {
					let mock: TestMock
					let container: CallContainer
					let times: TimesMatcher
					public init(mock: TestMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
					public func subscriptGetter<T: Equitable>(_ value: @escaping ArgumentMatcher<T> = any()) {
						let argumentMatcher0 = value
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "subscript<T: Equitable>(_ value: T) -> T { get set }")
					}
					public func subscriptSetter<T: Equitable>(_ value: @escaping ArgumentMatcher<T> = any(), newValue: @escaping ArgumentMatcher<T> = any()) {
						let argumentMatcher1 = newValue
						let argumentMatcher0 = zip(value, argumentMatcher1)
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "subscript<T: Equitable>(_ value: T) -> T { get set }")
					}
				}
				public let container = VerifyContainer()
				private let subscript_T__Equitable____value__T_____T___getter = MethodInvocationContainer()
				public func $subscriptGetter<T: Equitable>(_ value: @escaping ArgumentMatcher<T> = any()) -> MethodSignature<(T), T> {
					let argumentMatcher0 = value
					return MethodSignature<(T), T>(argumentMatcher: argumentMatcher0, register: {
							self.subscript_T__Equitable____value__T_____T___getter.append($0)
						})
				}
				private let subscript_T__Equitable____value__T_____T___setter = MethodInvocationContainer()
				public func $subscriptSetter<T: Equitable>(_ value: @escaping ArgumentMatcher<T> = any(), newValue: @escaping ArgumentMatcher<T> = any()) -> MethodSignature<(T, (T)), Void> {
					let argumentMatcher1 = newValue
					let argumentMatcher0 = zip(value, argumentMatcher1)
					return MethodSignature<(T, (T)), Void>(argumentMatcher: argumentMatcher0, register: {
							self.subscript_T__Equitable____value__T_____T___setter.append($0)
						})
				}
				public
					subscript <T: Equitable>(_ value: T) -> T {
					get {
						let arguments = (value)
						container.append(mock: self, call: MethodCall(arguments: arguments), function: "subscript<T: Equitable>(_ value: T) -> T { get set }")
						return subscript_T__Equitable____value__T_____T___getter.find(with: arguments, type: "TestMock", function: "subscript<T: Equitable>(_ value: T) -> T { get set }")
					}
					set {
						let arguments = (value, (newValue))
						container.append(mock: self, call: MethodCall(arguments: arguments), function: "subscript<T: Equitable>(_ value: T) -> T { get set }")
						return subscript_T__Equitable____value__T_____T___setter.find(with: arguments, type: "TestMock", function: "subscript<T: Equitable>(_ value: T) -> T { get set }")
					}
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
	
	func testTwoArguments() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				subscript(_ value0: Int, _ value1: Int) -> Int { get }
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				subscript(_ value0: Int, _ value1: Int) -> Int { get }
			}
			
			public final class TestMock: Test, Verifiable {
				public struct Verify: MockVerify {
					let mock: TestMock
					let container: CallContainer
					let times: TimesMatcher
					public init(mock: TestMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
					public func subscriptGetter(_ value0: @escaping ArgumentMatcher<Int> = any(), _ value1: @escaping ArgumentMatcher<Int> = any()) {
						let argumentMatcher1 = value1
						let argumentMatcher0 = zip(value0, argumentMatcher1)
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "subscript(_ value0: Int, _ value1: Int) -> Int { get }")
					}
				}
				public let container = VerifyContainer()
				private let subscript___value0__Int____value1__Int_____Int___getter = MethodInvocationContainer()
				public func $subscriptGetter(_ value0: @escaping ArgumentMatcher<Int> = any(), _ value1: @escaping ArgumentMatcher<Int> = any()) -> MethodSignature<(Int, (Int)), Int> {
					let argumentMatcher1 = value1
					let argumentMatcher0 = zip(value0, argumentMatcher1)
					return MethodSignature<(Int, (Int)), Int>(argumentMatcher: argumentMatcher0, register: {
							self.subscript___value0__Int____value1__Int_____Int___getter.append($0)
						})
				}
				public
					subscript(_ value0: Int, _ value1: Int) -> Int {
					get {
						let arguments = (value0, (value1))
						container.append(mock: self, call: MethodCall(arguments: arguments), function: "subscript(_ value0: Int, _ value1: Int) -> Int { get }")
						return subscript___value0__Int____value1__Int_____Int___getter.find(with: arguments, type: "TestMock", function: "subscript(_ value0: Int, _ value1: Int) -> Int { get }")
					}
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
