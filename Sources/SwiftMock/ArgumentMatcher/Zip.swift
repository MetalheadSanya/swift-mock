/// Creates a argument matcher of pairs built out of two underlying argument matcher.
///
/// - Parameters:
/// 	- argumentMatcher0: A argument matcher for zipping.
/// 	- argumentMatcher1: Another argument wrapper for zipping.
/// - Returns: ``ArgumentMatcher``.
public func zip<T0, T1>(
	_ argumentMatcher0: @escaping ArgumentMatcher<T0>,
	_ argumentMatcher1: @escaping ArgumentMatcher<T1>
) -> ArgumentMatcher<(T0, T1)> {
	{	arguments in
		argumentMatcher0(arguments.0) && argumentMatcher1(arguments.1)
	}
}
