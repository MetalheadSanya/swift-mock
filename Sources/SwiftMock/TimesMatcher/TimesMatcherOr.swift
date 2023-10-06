/// Creates a times matcher that tests method call count with two provided ``TimesMatcher``.
/// Created ``TimesMatcher`` tests that cal count satisfies any of the provided matchers.
///
///	- Parameters:
///		- mather0: First times mather. If times matcher successfully tests a method call count,
///			the second one won't be called.
///		- mather1: Second times mather.
/// - Returns: New ``TimesMatcher``.
public func ||(_ matcher0: @escaping TimesMatcher, _ matcher1: @escaping TimesMatcher) -> TimesMatcher {
	{ matcher0($0) || matcher1($0) }
}
