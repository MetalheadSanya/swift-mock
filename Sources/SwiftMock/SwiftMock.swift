@attached(peer, names: suffixed(Mock))
public macro Mock() = #externalMacro(module: "SwiftMockMacros", type: "MockMacro")

