/// Creates an argument matcher that tests an argument with two provided ``ArgumentMatcher``.
/// Created ``ArgumentMatcher`` tests that argument satisfies any of the provided matchers.
///
///	- Parameters:
///		- mather0: First argument mather. If this argumen matcher successfully tests an argument,
///			the second one won't be called.
///		- mather1: Second argument mather.
/// - Returns: ``ArgumentMatcher``.
public func ||<T>(
	_ mather0: @escaping ArgumentMatcher<T>,
	_ mather1: @escaping ArgumentMatcher<T>
) -> ArgumentMatcher<T> {
	{ (argument) in
		mather0(argument) || mather1(argument)
	}
}
