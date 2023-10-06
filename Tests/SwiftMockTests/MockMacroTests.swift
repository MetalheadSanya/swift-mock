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
			public protocol Test { }
			""",
			expandedSource: 
			"""
			public protocol Test { }
			
			public final class TestMock: Test , Verifiable {
				public struct Verify: MockVerify {
					let mock: TestMock
					let times: TimesMatcher
					public init(mock: TestMock, times: @escaping TimesMatcher) {
						self.mock = mock
						self.times = times
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
					let times: TimesMatcher
					public init(mock: TestMock, times: @escaping TimesMatcher) {
						self.mock = mock
						self.times = times
					}
					public
						func call() -> Void {
						MethodCall.verify(in: mock.call_____call, matcher: any(), times: times, type: "TestMock")
					}
				}
				private var call__: [MethodInvocation<(), Void>] = []
				private var call_____call: [MethodCall<()>] = []
				public
					func $call() -> MethodSignature<(), Void> {
					return MethodSignature<(), Void>(argumentMatcher: any(), register: {
							self.call__.append($0)
						})
				}
				public
					func call() {
					let arguments = ()
					call_____call.append(MethodCall(arguments: arguments))
					return MethodInvocation.find(in: call__, with: arguments, type: "TestMock")
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
					let times: TimesMatcher
					public init(mock: TestMock, times: @escaping TimesMatcher) {
						self.mock = mock
						self.times = times
					}
					public
						func call() -> Void {
						MethodCall.verify(in: mock.call_____call, matcher: any(), times: times, type: "TestMock")
					}
				}
				private var call__: [MethodInvocation<(), Int>] = []
				private var call_____call: [MethodCall<()>] = []
				public
					func $call() -> MethodSignature<(), Int> {
					return MethodSignature<(), Int>(argumentMatcher: any(), register: {
							self.call__.append($0)
						})
				}
				public
					func call() -> Int {
					let arguments = ()
					call_____call.append(MethodCall(arguments: arguments))
					return MethodInvocation.find(in: call__, with: arguments, type: "TestMock")
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
					let times: TimesMatcher
					public init(mock: TestMock, times: @escaping TimesMatcher) {
						self.mock = mock
						self.times = times
					}
					public
						func call(argument: @escaping ArgumentMatcher<Int> = any()) -> Void {
						let argumentMatcher0 = argument
						MethodCall.verify(in: mock.call_argument____call, matcher: argumentMatcher0, times: times, type: "TestMock")
					}
				}
				private var call_argument_: [MethodInvocation<(Int), Void>] = []
				private var call_argument____call: [MethodCall<(Int)>] = []
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
					call_argument____call.append(MethodCall(arguments: arguments))
					return MethodInvocation.find(in: call_argument_, with: arguments, type: "TestMock")
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
					let times: TimesMatcher
					public init(mock: TestMock, times: @escaping TimesMatcher) {
						self.mock = mock
						self.times = times
					}
					public
						func call(argument0: @escaping ArgumentMatcher<Int> = any(), argument1: @escaping ArgumentMatcher<Int> = any()) -> Void {
						let argumentMatcher1 = argument1
						let argumentMatcher0 = zip(argument0, argumentMatcher1)
						MethodCall.verify(in: mock.call_argument0_argument1____call, matcher: argumentMatcher0, times: times, type: "TestMock")
					}
				}
				private var call_argument0_argument1_: [MethodInvocation<(Int, (Int)), Void>] = []
				private var call_argument0_argument1____call: [MethodCall<(Int, (Int))>] = []
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
					call_argument0_argument1____call.append(MethodCall(arguments: arguments))
					return MethodInvocation.find(in: call_argument0_argument1_, with: arguments, type: "TestMock")
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
					let times: TimesMatcher
					public init(mock: TestMock, times: @escaping TimesMatcher) {
						self.mock = mock
						self.times = times
					}
					public
						func call(argument0: @escaping ArgumentMatcher<Int> = any(), argument1: @escaping ArgumentMatcher<Int> = any()) -> Void {
						let argumentMatcher1 = argument1
						let argumentMatcher0 = zip(argument0, argumentMatcher1)
						MethodCall.verify(in: mock.call_argument0_argument1_throws___call, matcher: argumentMatcher0, times: times, type: "TestMock")
					}
				}
				private var call_argument0_argument1_throws: [ThrowsMethodInvocation<(Int, (Int)), Int>] = []
				private var call_argument0_argument1_throws___call: [MethodCall<(Int, (Int))>] = []
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
					call_argument0_argument1_throws___call.append(MethodCall(arguments: arguments))
					return try ThrowsMethodInvocation.find(in: call_argument0_argument1_throws, with: arguments, type: "TestMock")
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
					let times: TimesMatcher
					public init(mock: TestMock, times: @escaping TimesMatcher) {
						self.mock = mock
						self.times = times
					}
					public
						func call(argument0: @escaping ArgumentMatcher<Int> = any(), argument1: @escaping ArgumentMatcher<Int> = any()) -> Void {
						let argumentMatcher1 = argument1
						let argumentMatcher0 = zip(argument0, argumentMatcher1)
						MethodCall.verify(in: mock.call_argument0_argument1_async___call, matcher: argumentMatcher0, times: times, type: "TestMock")
					}
				}
				private var call_argument0_argument1_async: [AsyncMethodInvocation<(Int, (Int)), Int>] = []
				private var call_argument0_argument1_async___call: [MethodCall<(Int, (Int))>] = []
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
					call_argument0_argument1_async___call.append(MethodCall(arguments: arguments))
					return await AsyncMethodInvocation.find(in: call_argument0_argument1_async, with: arguments, type: "TestMock")
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
					let times: TimesMatcher
					public init(mock: TestMock, times: @escaping TimesMatcher) {
						self.mock = mock
						self.times = times
					}
					public
						func call(argument0: @escaping ArgumentMatcher<Int> = any(), argument1: @escaping ArgumentMatcher<Int> = any()) -> Void {
						let argumentMatcher1 = argument1
						let argumentMatcher0 = zip(argument0, argumentMatcher1)
						MethodCall.verify(in: mock.call_argument0_argument1_asyncthrows___call, matcher: argumentMatcher0, times: times, type: "TestMock")
					}
				}
				private var call_argument0_argument1_asyncthrows: [AsyncThrowsMethodInvocation<(Int, (Int)), Int>] = []
				private var call_argument0_argument1_asyncthrows___call: [MethodCall<(Int, (Int))>] = []
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
					call_argument0_argument1_asyncthrows___call.append(MethodCall(arguments: arguments))
					return try await AsyncThrowsMethodInvocation.find(in: call_argument0_argument1_asyncthrows, with: arguments, type: "TestMock")
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
