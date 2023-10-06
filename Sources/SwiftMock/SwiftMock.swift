@attached(peer, names: suffixed(Mock))
public macro Mock() = #externalMacro(module: "SwiftMockMacros", type: "MockMacro")

public var testFailureReport: (String) -> Void = { _ in
	
}

