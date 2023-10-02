/// Tests that the argument is equal to the given value.
///
/// - Parameters:
///		- value: The value with which to compare the argument value.
/// - Returns: ``ArgumentMatcher``.
public func eq<Arguments>(_ value: Arguments) -> ArgumentMatcher<Arguments> where Arguments: Equatable {
	{ argument in
		argument == value
	}
}
