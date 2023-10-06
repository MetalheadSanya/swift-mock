/// Checks that method was called at most `count` times.
///
/// - Parameters:
/// 	- count: Maximum acceptable call count.
///
/// - Returns: New ``TimesMatcher``,
public func atMost(_ count: Int) -> TimesMatcher {
	{ $0 <= count }
}
