@attached(peer, names: suffixed(Mock))
public macro Mock() = #externalMacro(module: "SwiftMockMacros", type: "MockMacro")

public var testFailureReport: (String, StaticString, UInt) -> Void = { _, _, _ in
	assertionFailure("Please import SwiftMockConfiguration module and call 'SwiftMockConfiguration.setUp()' in 'setUp()' method of your XCTestCase subclass.")
}

public func cleanUpMock() {
	InOrderContainer.clear()
}

