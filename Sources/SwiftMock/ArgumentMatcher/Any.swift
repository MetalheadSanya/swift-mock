/// Any possible value is suitable.
///
/// - Returns: ``ArgumentMatcher``.
public func any<Arguments>() -> ArgumentMatcher<Arguments> {
	{ _ in
		true
	}
}
