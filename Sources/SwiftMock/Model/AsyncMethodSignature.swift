import Foundation

public struct AsyncMethodSignature<Arguments, Result> {
	let argumentMatcher: ArgumentMatcher<Arguments>
	let register: (AsyncMethodInvocation<Arguments, Result>) -> Void
	
	public init(
		argumentMatcher: @escaping ArgumentMatcher<Arguments>,
		register: @escaping (AsyncMethodInvocation<Arguments, Result>) -> Void
	) {
		self.argumentMatcher = argumentMatcher
		self.register = register
	}
}
