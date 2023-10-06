/// Checks that method wasn't called.
///
/// - Returns: New ``TimesMatcher``.
public func never() -> TimesMatcher {
	times(0)
}
