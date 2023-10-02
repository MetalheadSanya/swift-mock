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
			
			public final class TestMock: Test {
			}
			""",
			macros: testMacros
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
			
			public final class TestMock: Test {
				private var call__: [MethodInvocation<(), Void>] = []
				public
					func $call() -> MethodSignature<(), Void> {
					return MethodSignature<(), Void>(argumentMatcher: any(), register: {
							self.call__.append($0)
						})
				}
				public
					func call() {
					MethodInvocation.find(in: call__, with: (), type: "TestMock")
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
			
			public final class TestMock: Test {
				private var call__: [MethodInvocation<(), Int>] = []
				public
					func $call() -> MethodSignature<(), Int> {
					return MethodSignature<(), Int>(argumentMatcher: any(), register: {
							self.call__.append($0)
						})
				}
				public
					func call() -> Int {
					MethodInvocation.find(in: call__, with: (), type: "TestMock")
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
			
			public final class TestMock: Test {
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
					MethodInvocation.find(in: call_argument_, with: (argument), type: "TestMock")
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
			
			public final class TestMock: Test {
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
					MethodInvocation.find(in: call_argument0_argument1_, with: (argument0, (argument1)), type: "TestMock")
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
			
			public final class TestMock: Test {
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
					try ThrowsMethodInvocation.find(in: call_argument0_argument1_throws, with: (argument0, (argument1)), type: "TestMock")
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
			
			public final class TestMock: Test {
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
					await AsyncMethodInvocation.find(in: call_argument0_argument1_async, with: (argument0, (argument1)), type: "TestMock")
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
	
	func testAsyncthrowsFunction() {
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
			
			public final class TestMock: Test {
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
					try await AsyncThrowsMethodInvocation.find(in: call_argument0_argument1_asyncthrows, with: (argument0, (argument1)), type: "TestMock")
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
