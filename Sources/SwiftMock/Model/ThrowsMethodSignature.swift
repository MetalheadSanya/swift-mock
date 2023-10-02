import Foundation

public struct ThrowsMethodSignature<Arguments, Result> {
	let argumentMatcher: ArgumentMatcher<Arguments>
	let register: (ThrowsMethodInvocation<Arguments, Result>) -> Void
	
	public init(
		argumentMatcher: @escaping ArgumentMatcher<Arguments>,
		register: @escaping (ThrowsMethodInvocation<Arguments, Result>) -> Void
	) {
		self.argumentMatcher = argumentMatcher
		self.register = register
	}
}
