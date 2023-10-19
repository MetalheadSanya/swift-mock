import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(SwiftMockMacros)
import SwiftMockMacros

private let testMacros: [String: Macro.Type] = [
	"Mock": MockMacro.self,
]
#endif

final class MockMacroTests: XCTestCase {
	func testEmptyProtocol() {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test: AnyObject { }
			""",
			expandedSource: 
			"""
			public protocol Test: AnyObject { }
			
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
				}
				public let container = VerifyContainer()
			}
			""",
			macros: testMacros,
			indentationWidth: .tab
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}
	
	func testInternalProtocol() {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			internal protocol Test: AnyObject { }
			""",
			expandedSource:
			"""
			internal protocol Test: AnyObject { }
			
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
	
	func testFunctionWithoutArgumentsAndReturnType() {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				func call()
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				func call()
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
						func call() -> Void {
						let argumentMatcher0: ArgumentMatcher<()> = any()
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "call()")
					}
				}
				public let container = VerifyContainer()
				private var call__: [MethodInvocation<(), Void>] = []
				public
					func $call() -> MethodSignature<(), Void> {
					let argumentMatcher0: ArgumentMatcher<()> = any()
					return MethodSignature<(), Void>(argumentMatcher: argumentMatcher0, register: {
							self.call__.append($0)
						})
				}
				public
					func call() {
					let arguments = ()
					container.append(mock: self, call: MethodCall(arguments: arguments), function: "call()")
					return MethodInvocation.find(in: call__, with: arguments, type: "TestMock", function: "call()")
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
	
	func testGetProperty() {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				var prop: Int { get }
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				var prop: Int { get }
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
					public func propGetter() {
						let argumentMatcher0: ArgumentMatcher<()> = any()
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "prop")
					}
				}
				public let container = VerifyContainer()
				private var prop___getter: [MethodInvocation<(), Int>] = []
				public func $propGetter() -> MethodSignature<(), Int> {
					return MethodSignature<(), Int>(argumentMatcher: any(), register: {
							self.prop___getter.append($0)
						})
				}
				public var prop: Int {
					get {
						let arguments = ()
						container.append(mock: self, call: MethodCall(arguments: arguments), function: "prop")
						return MethodInvocation.find(in: prop___getter, with: arguments, type: "TestMock", function: "prop")
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
	
	func testGetSetProperty() {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				var prop: Int { get set }
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				var prop: Int { get set }
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
					public func propGetter() {
						let argumentMatcher0: ArgumentMatcher<()> = any()
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "prop")
					}
					public func propSetter(_ value: @escaping ArgumentMatcher<Int>) {
						let argumentMatcher0 = value
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "prop=")
					}
				}
				public let container = VerifyContainer()
				private var prop___getter: [MethodInvocation<(), Int>] = []
				public func $propGetter() -> MethodSignature<(), Int> {
					return MethodSignature<(), Int>(argumentMatcher: any(), register: {
							self.prop___getter.append($0)
						})
				}
				private var prop___setter: [MethodInvocation<(Int), Void>] = []
				public func $propSetter(_ value: @escaping ArgumentMatcher<Int> = any()) -> MethodSignature<(Int), Void> {
					let argumentMatcher0 = value
					return MethodSignature<(Int), Void>(argumentMatcher: argumentMatcher0, register: {
							self.prop___setter.append($0)
						})
				}
				public var prop: Int {
					get {
						let arguments = ()
						container.append(mock: self, call: MethodCall(arguments: arguments), function: "prop")
						return MethodInvocation.find(in: prop___getter, with: arguments, type: "TestMock", function: "prop")
					}
					set {
						let arguments = (newValue)
						container.append(mock: self, call: MethodCall(arguments: arguments), function: "prop=")
						return MethodInvocation.find(in: prop___setter, with: arguments, type: "TestMock", function: "prop=")
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
	
	func testGetThrowsProperty() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				var prop: Int { get throws }
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				var prop: Int { get throws }
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
					public func propGetter() {
						let argumentMatcher0: ArgumentMatcher<()> = any()
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "prop throws")
					}
				}
				public let container = VerifyContainer()
				private var prop___getter: [ThrowsMethodInvocation<(), Int>] = []
				public func $propGetter() -> ThrowsMethodSignature<(), Int> {
					return ThrowsMethodSignature<(), Int>(argumentMatcher: any(), register: {
							self.prop___getter.append($0)
						})
				}
				public var prop: Int {
					get throws {
						let arguments = ()
						container.append(mock: self, call: MethodCall(arguments: arguments), function: "prop throws")
						return try ThrowsMethodInvocation.find(in: prop___getter, with: arguments, type: "TestMock", function: "prop throws")
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
	
	func testGetAsyncProperty() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				var prop: Int { get async }
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				var prop: Int { get async }
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
					public func propGetter() {
						let argumentMatcher0: ArgumentMatcher<()> = any()
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "prop async")
					}
				}
				public let container = VerifyContainer()
				private var prop___getter: [AsyncMethodInvocation<(), Int>] = []
				public func $propGetter() -> AsyncMethodSignature<(), Int> {
					return AsyncMethodSignature<(), Int>(argumentMatcher: any(), register: {
							self.prop___getter.append($0)
						})
				}
				public var prop: Int {
					get async {
						let arguments = ()
						container.append(mock: self, call: MethodCall(arguments: arguments), function: "prop async")
						return await AsyncMethodInvocation.find(in: prop___getter, with: arguments, type: "TestMock", function: "prop async")
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
	
	func testGetAsyncThrowsProperty() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				var prop: Int { get async throws }
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				var prop: Int { get async throws }
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
					public func propGetter() {
						let argumentMatcher0: ArgumentMatcher<()> = any()
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "prop async throws")
					}
				}
				public let container = VerifyContainer()
				private var prop___getter: [AsyncThrowsMethodInvocation<(), Int>] = []
				public func $propGetter() -> AsyncThrowsMethodSignature<(), Int> {
					return AsyncThrowsMethodSignature<(), Int>(argumentMatcher: any(), register: {
							self.prop___getter.append($0)
						})
				}
				public var prop: Int {
					get async throws {
						let arguments = ()
						container.append(mock: self, call: MethodCall(arguments: arguments), function: "prop async throws")
						return try await AsyncThrowsMethodInvocation.find(in: prop___getter, with: arguments, type: "TestMock", function: "prop async throws")
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

	func testFunctionWithoutArguments() {
	#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				func call() -> Int
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				func call() -> Int
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
						func call() -> Void {
						let argumentMatcher0: ArgumentMatcher<()> = any()
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "call() -> Int")
					}
				}
				public let container = VerifyContainer()
				private var call__: [MethodInvocation<(), Int>] = []
				public
					func $call() -> MethodSignature<(), Int> {
					let argumentMatcher0: ArgumentMatcher<()> = any()
					return MethodSignature<(), Int>(argumentMatcher: argumentMatcher0, register: {
							self.call__.append($0)
						})
				}
				public
					func call() -> Int {
					let arguments = ()
					container.append(mock: self, call: MethodCall(arguments: arguments), function: "call() -> Int")
					return MethodInvocation.find(in: call__, with: arguments, type: "TestMock", function: "call() -> Int")
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
	
	func testFunctionWitOneArgument() {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				func call(argument: Int)
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				func call(argument: Int)
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
						func call(argument: @escaping ArgumentMatcher<Int> = any()) -> Void {
						let argumentMatcher0 = argument
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "call(argument:)")
					}
				}
				public let container = VerifyContainer()
				private var call_argument_: [MethodInvocation<(Int), Void>] = []
				public
					func $call(argument: @escaping ArgumentMatcher<Int> = any()) -> MethodSignature<(Int), Void> {
					let argumentMatcher0 = argument
					return MethodSignature<(Int), Void>(argumentMatcher: argumentMatcher0, register: {
							self.call_argument_.append($0)
						})
				}
				public
					func call(argument: Int) {
					let arguments = (argument)
					container.append(mock: self, call: MethodCall(arguments: arguments), function: "call(argument:)")
					return MethodInvocation.find(in: call_argument_, with: arguments, type: "TestMock", function: "call(argument:)")
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
	
	func testFunctionWithTwoArgument() {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				func call(argument0: Int, argument1: Int)
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				func call(argument0: Int, argument1: Int)
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
						func call(argument0: @escaping ArgumentMatcher<Int> = any(), argument1: @escaping ArgumentMatcher<Int> = any()) -> Void {
						let argumentMatcher1 = argument1
						let argumentMatcher0 = zip(argument0, argumentMatcher1)
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "call(argument0:argument1:)")
					}
				}
				public let container = VerifyContainer()
				private var call_argument0_argument1_: [MethodInvocation<(Int, (Int)), Void>] = []
				public
					func $call(argument0: @escaping ArgumentMatcher<Int> = any(), argument1: @escaping ArgumentMatcher<Int> = any()) -> MethodSignature<(Int, (Int)), Void> {
					let argumentMatcher1 = argument1
					let argumentMatcher0 = zip(argument0, argumentMatcher1)
					return MethodSignature<(Int, (Int)), Void>(argumentMatcher: argumentMatcher0, register: {
							self.call_argument0_argument1_.append($0)
						})
				}
				public
					func call(argument0: Int, argument1: Int) {
					let arguments = (argument0, (argument1))
					container.append(mock: self, call: MethodCall(arguments: arguments), function: "call(argument0:argument1:)")
					return MethodInvocation.find(in: call_argument0_argument1_, with: arguments, type: "TestMock", function: "call(argument0:argument1:)")
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
	
	func testFunctionThatThrows() {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				func call(argument0: Int, argument1: Int) throws -> Int
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				func call(argument0: Int, argument1: Int) throws -> Int
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
						func call(argument0: @escaping ArgumentMatcher<Int> = any(), argument1: @escaping ArgumentMatcher<Int> = any()) -> Void {
						let argumentMatcher1 = argument1
						let argumentMatcher0 = zip(argument0, argumentMatcher1)
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "call(argument0:argument1:) throws -> Int")
					}
				}
				public let container = VerifyContainer()
				private var call_argument0_argument1_throws: [ThrowsMethodInvocation<(Int, (Int)), Int>] = []
				public
					func $call(argument0: @escaping ArgumentMatcher<Int> = any(), argument1: @escaping ArgumentMatcher<Int> = any()) -> ThrowsMethodSignature<(Int, (Int)), Int> {
					let argumentMatcher1 = argument1
					let argumentMatcher0 = zip(argument0, argumentMatcher1)
					return ThrowsMethodSignature<(Int, (Int)), Int>(argumentMatcher: argumentMatcher0, register: {
							self.call_argument0_argument1_throws.append($0)
						})
				}
				public
					func call(argument0: Int, argument1: Int) throws -> Int {
					let arguments = (argument0, (argument1))
					container.append(mock: self, call: MethodCall(arguments: arguments), function: "call(argument0:argument1:) throws -> Int")
					return try ThrowsMethodInvocation.find(in: call_argument0_argument1_throws, with: arguments, type: "TestMock", function: "call(argument0:argument1:) throws -> Int")
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
	
	func testAsyncFunction() {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				func call(argument0: Int, argument1: Int) async -> Int
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				func call(argument0: Int, argument1: Int) async -> Int
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
						func call(argument0: @escaping ArgumentMatcher<Int> = any(), argument1: @escaping ArgumentMatcher<Int> = any()) -> Void {
						let argumentMatcher1 = argument1
						let argumentMatcher0 = zip(argument0, argumentMatcher1)
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "call(argument0:argument1:) async -> Int")
					}
				}
				public let container = VerifyContainer()
				private var call_argument0_argument1_async: [AsyncMethodInvocation<(Int, (Int)), Int>] = []
				public
					func $call(argument0: @escaping ArgumentMatcher<Int> = any(), argument1: @escaping ArgumentMatcher<Int> = any()) -> AsyncMethodSignature<(Int, (Int)), Int> {
					let argumentMatcher1 = argument1
					let argumentMatcher0 = zip(argument0, argumentMatcher1)
					return AsyncMethodSignature<(Int, (Int)), Int>(argumentMatcher: argumentMatcher0, register: {
							self.call_argument0_argument1_async.append($0)
						})
				}
				public
					func call(argument0: Int, argument1: Int) async -> Int {
					let arguments = (argument0, (argument1))
					container.append(mock: self, call: MethodCall(arguments: arguments), function: "call(argument0:argument1:) async -> Int")
					return await AsyncMethodInvocation.find(in: call_argument0_argument1_async, with: arguments, type: "TestMock", function: "call(argument0:argument1:) async -> Int")
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
	
	func testAsyncThrowsFunction() {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			public protocol Test {
				func call(argument0: Int, argument1: Int) async throws -> Int
			}
			""",
			expandedSource:
			"""
			public protocol Test {
				func call(argument0: Int, argument1: Int) async throws -> Int
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
						func call(argument0: @escaping ArgumentMatcher<Int> = any(), argument1: @escaping ArgumentMatcher<Int> = any()) -> Void {
						let argumentMatcher1 = argument1
						let argumentMatcher0 = zip(argument0, argumentMatcher1)
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TestMock", function: "call(argument0:argument1:) async throws -> Int")
					}
				}
				public let container = VerifyContainer()
				private var call_argument0_argument1_asyncthrows: [AsyncThrowsMethodInvocation<(Int, (Int)), Int>] = []
				public
					func $call(argument0: @escaping ArgumentMatcher<Int> = any(), argument1: @escaping ArgumentMatcher<Int> = any()) -> AsyncThrowsMethodSignature<(Int, (Int)), Int> {
					let argumentMatcher1 = argument1
					let argumentMatcher0 = zip(argument0, argumentMatcher1)
					return AsyncThrowsMethodSignature<(Int, (Int)), Int>(argumentMatcher: argumentMatcher0, register: {
							self.call_argument0_argument1_asyncthrows.append($0)
						})
				}
				public
					func call(argument0: Int, argument1: Int) async throws -> Int {
					let arguments = (argument0, (argument1))
					container.append(mock: self, call: MethodCall(arguments: arguments), function: "call(argument0:argument1:) async throws -> Int")
					return try await AsyncThrowsMethodInvocation.find(in: call_argument0_argument1_asyncthrows, with: arguments, type: "TestMock", function: "call(argument0:argument1:) async throws -> Int")
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
