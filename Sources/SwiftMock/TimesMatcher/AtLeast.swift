/// Checks that method was calles at least `count` times.
///
/// - Parameters:
/// 	- count: Minimum acceptable call count.
///
/// - Returns: New ``TimesMatcher``.
public func atLeast(_ count: Int) -> TimesMatcher {
	{ $0 >= count }
}

/// Checks that method was calles at least once.
///
/// - Returns: New ``TimesMatcher``.
public func atLeastOnce() -> TimesMatcher {
	atLeast(1)
}
