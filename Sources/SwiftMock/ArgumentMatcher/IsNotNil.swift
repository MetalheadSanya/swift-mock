/// Tests that the argument isn't equal to `nil`.
///
/// - Returns: ``ArgumentMatcher``.
public func isNotNil<T>() -> ArgumentMatcher<T?> {
	{ argument in
		argument != nil
	}
}
