/// Tests that the argument is more than the given value.
///
/// - Parameters:
///		- value: The value with which to compare the argument value.
/// - Returns: ``ArgumentMatcher``.
public func moreThen<T>(_ value: T) -> ArgumentMatcher<T> where T: Comparable {
	{ (argument) in
		argument > value
	}
}
