/// Tests that the argument is equal to `nil`.
///
/// - Returns: ``ArgumentMatcher``.
public func isNil<T>() -> ArgumentMatcher<T?> {
	{ argument in
		argument == nil
	}
}
