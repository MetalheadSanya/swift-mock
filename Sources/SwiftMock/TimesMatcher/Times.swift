/// Checks that method was called exactly `count` times.
///
/// - Parameters:
/// 		- count: Count of calls.
/// - Returns: New ``TimesMatcher``.
public func times(_ count: Int) -> TimesMatcher {
	{ $0 == count }
}
