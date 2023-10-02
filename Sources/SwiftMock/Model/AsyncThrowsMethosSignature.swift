import Foundation

public struct AsyncThrowsMethodSignature<Arguments, Result> {
	let argumentMatcher: ArgumentMatcher<Arguments>
	let register: (AsyncThrowsMethodInvocation<Arguments, Result>) -> Void
	
	public init(
		argumentMatcher: @escaping ArgumentMatcher<Arguments>,
		register: @escaping (AsyncThrowsMethodInvocation<Arguments, Result>) -> Void
	) {
		self.argumentMatcher = argumentMatcher
		self.register = register
	}
}
