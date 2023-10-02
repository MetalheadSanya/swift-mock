/// Creates an argument matcher that tests an argument with two provided ``ArgumentMatcher``.
/// Created ``ArgumentMatcher`` tests that argument satisfies both provided matchers.
///
/// - Parameters:
///
///	- Parameters:
///		- mather0: First argument mather. If this argumen matcher unsuccessfully tests an argument,
///			the second one won't be called.
///		- mather1: Second argument mather.
/// - Returns: ``ArgumentMatcher``.
public func &&<T>(_ matcher0: @escaping ArgumentMatcher<T>, _ matcher1: @escaping ArgumentMatcher<T>) -> ArgumentMatcher<T> {
	{ argument in
		matcher0(argument) && matcher1(argument)
	}
}
