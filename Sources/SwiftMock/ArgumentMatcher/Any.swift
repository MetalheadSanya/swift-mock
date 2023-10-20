/// Any possible value is suitable.
///
/// - Returns: ``ArgumentMatcher``.
public func any<Arguments>() -> ArgumentMatcher<Arguments> {
	{ _ in
		true
	}
}

/// Any possible value is suitable.
///
/// - Returns: ``ArgumentMatcher``.
public func any<T>(type: T.Type) -> ArgumentMatcher<T> {
	{ _ in
		true
	}
}

