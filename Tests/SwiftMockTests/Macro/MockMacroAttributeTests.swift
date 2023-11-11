import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(SwiftMockMacros)
import SwiftMockMacros

private let testMacros: [String: Macro.Type] = [
	"Mock": MockMacro.self,
]
#endif

final class MockMacroAttributeTests: XCTestCase {
	func testAvailableAttribute() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			@available(iOS, introduced: 15.1)
			public protocol Test: AnyObject { }
			""",
			expandedSource:
			"""
			@available(iOS, introduced: 15.1)
			public protocol Test: AnyObject { }
			
			@available(iOS, introduced: 15.1) public final class TestMock: Test, Verifiable {
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
				public init() {
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
	
	func testTwoAvailableAttributes() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			@available(swift, introduced: 4.0.2)
			@available(iOS, introduced: 15.1)
			public protocol Test: AnyObject { }
			""",
			expandedSource:
			"""
			@available(swift, introduced: 4.0.2)
			@available(iOS, introduced: 15.1)
			public protocol Test: AnyObject { }
			
			@available(swift, introduced: 4.0.2)
			@available(iOS, introduced: 15.1) public final class TestMock: Test, Verifiable {
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
				public init() {
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
	
	func testDynamicCallable() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			@dynamicCallable
			protocol TelephoneExchange {
				func dynamicallyCall(withArguments phoneNumber: [Int])
			}
			""",
			expandedSource:
			"""
			@dynamicCallable
			protocol TelephoneExchange {
				func dynamicallyCall(withArguments phoneNumber: [Int])
			}
			
			@dynamicCallable final class TelephoneExchangeMock: TelephoneExchange , Verifiable {
				struct Verify: MockVerify {
					let mock: TelephoneExchangeMock
					let container: CallContainer
					let times: TimesMatcher
					init(mock: TelephoneExchangeMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
						func dynamicallyCall(withArguments phoneNumber: @escaping ArgumentMatcher<[Int]> = any()) -> Void {
						let argumentMatcher0 = phoneNumber
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TelephoneExchangeMock", function: "dynamicallyCall(withArguments:)")
					}
				}
				let container = VerifyContainer()
				private let dynamicallyCall_withArguments_ = MethodInvocationContainer()
					func $dynamicallyCall(withArguments phoneNumber: @escaping ArgumentMatcher<[Int]> = any()) -> MethodSignature<([Int]), Void> {
					let argumentMatcher0 = phoneNumber
					return MethodSignature<([Int]), Void>(argumentMatcher: argumentMatcher0, register: {
							self.dynamicallyCall_withArguments_.append($0)
						})
				}
				func dynamicallyCall(withArguments phoneNumber: [Int]) {
					let arguments = (phoneNumber)
					container.append(mock: self, call: MethodCall(arguments: arguments), function: "dynamicallyCall(withArguments:)")
					return dynamicallyCall_withArguments_.find(with: arguments, type: "TelephoneExchangeMock", function: "dynamicallyCall(withArguments:)")
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
	
	func testDynamicMemberLookupCallable() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			@dynamicMemberLookup
			protocol SomeProtocol {
				subscript(dynamicMember member: String) -> Int { get }
			}
			""",
			expandedSource:
			"""
			@dynamicMemberLookup
			protocol SomeProtocol {
				subscript(dynamicMember member: String) -> Int { get }
			}
			
			@dynamicMemberLookup final class SomeProtocolMock: SomeProtocol , Verifiable {
				struct Verify: MockVerify {
					let mock: SomeProtocolMock
					let container: CallContainer
					let times: TimesMatcher
					init(mock: SomeProtocolMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
					func subscriptGetter(dynamicMember member: @escaping ArgumentMatcher<String> = any()) {
						let argumentMatcher0 = member
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "SomeProtocolMock", function: "subscript(dynamicMember member: String) -> Int { get }")
					}
				}
				let container = VerifyContainer()
				private let subscript_dynamicMember_member__String_____Int___getter = MethodInvocationContainer()
				func $subscriptGetter(dynamicMember member: @escaping ArgumentMatcher<String> = any()) -> MethodSignature<(String), Int> {
					let argumentMatcher0 = member
					return MethodSignature<(String), Int>(argumentMatcher: argumentMatcher0, register: {
							self.subscript_dynamicMember_member__String_____Int___getter.append($0)
						})
				}
					subscript(dynamicMember member: String) -> Int {
					get {
						let arguments = (member)
						container.append(mock: self, call: MethodCall(arguments: arguments), function: "subscript(dynamicMember member: String) -> Int { get }")
						return subscript_dynamicMember_member__String_____Int___getter.find(with: arguments, type: "SomeProtocolMock", function: "subscript(dynamicMember member: String) -> Int { get }")
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
	
	func testObjc() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			@objc
			protocol TelephoneExchange {
				var test: Int { get }
			}
			""",
			expandedSource:
			"""
			@objc
			protocol TelephoneExchange {
				var test: Int { get }
			}
			
			@objc final class TelephoneExchangeMock: NSObject, TelephoneExchange , Verifiable {
				struct Verify: MockVerify {
					let mock: TelephoneExchangeMock
					let container: CallContainer
					let times: TimesMatcher
					init(mock: TelephoneExchangeMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
					func testGetter() {
						let argumentMatcher0: ArgumentMatcher<()> = any()
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TelephoneExchangeMock", function: "test")
					}
				}
				let container = VerifyContainer()
				private let test___getter = MethodInvocationContainer()
				func $testGetter() -> MethodSignature<(), Int> {
					return MethodSignature<(), Int>(argumentMatcher: any(), register: {
							self.test___getter.append($0)
						})
				}
				var test: Int {
					get {
						let arguments = ()
						container.append(mock: self, call: MethodCall(arguments: arguments), function: "test")
						return test___getter.find(with: arguments, type: "TelephoneExchangeMock", function: "test")
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
	
	func testObjcWithName() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			@objc(AZMTelephoneExchange)
			protocol TelephoneExchange {
				var test: Int { get }
			}
			""",
			expandedSource:
			"""
			@objc(AZMTelephoneExchange)
			protocol TelephoneExchange {
				var test: Int { get }
			}
			
			@objc final class TelephoneExchangeMock: NSObject, TelephoneExchange , Verifiable {
				struct Verify: MockVerify {
					let mock: TelephoneExchangeMock
					let container: CallContainer
					let times: TimesMatcher
					init(mock: TelephoneExchangeMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
					func testGetter() {
						let argumentMatcher0: ArgumentMatcher<()> = any()
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TelephoneExchangeMock", function: "test")
					}
				}
				let container = VerifyContainer()
				private let test___getter = MethodInvocationContainer()
				func $testGetter() -> MethodSignature<(), Int> {
					return MethodSignature<(), Int>(argumentMatcher: any(), register: {
							self.test___getter.append($0)
						})
				}
				var test: Int {
					get {
						let arguments = ()
						container.append(mock: self, call: MethodCall(arguments: arguments), function: "test")
						return test___getter.find(with: arguments, type: "TelephoneExchangeMock", function: "test")
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
	
	func testUnknownName() throws {
		#if canImport(SwiftMockMacros)
		assertMacroExpansion(
			"""
			@Mock
			@ComplerionHandler
			protocol TelephoneExchange {
				var test: Int { get }
			}
			""",
			expandedSource:
			"""
			@ComplerionHandler
			protocol TelephoneExchange {
				var test: Int { get }
			}
			
			@ComplerionHandler final class TelephoneExchangeMock: TelephoneExchange , Verifiable {
				struct Verify: MockVerify {
					let mock: TelephoneExchangeMock
					let container: CallContainer
					let times: TimesMatcher
					init(mock: TelephoneExchangeMock, container: CallContainer, times: @escaping TimesMatcher) {
						self.mock = mock
						self.container = container
						self.times = times
					}
					func testGetter() {
						let argumentMatcher0: ArgumentMatcher<()> = any()
						container.verify(mock: mock, matcher: argumentMatcher0, times: times, type: "TelephoneExchangeMock", function: "test")
					}
				}
				let container = VerifyContainer()
				private let test___getter = MethodInvocationContainer()
				func $testGetter() -> MethodSignature<(), Int> {
					return MethodSignature<(), Int>(argumentMatcher: any(), register: {
							self.test___getter.append($0)
						})
				}
				var test: Int {
					get {
						let arguments = ()
						container.append(mock: self, call: MethodCall(arguments: arguments), function: "test")
						return test___getter.find(with: arguments, type: "TelephoneExchangeMock", function: "test")
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
