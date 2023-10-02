public final class AsyncMethodInvocationBuilder<Arguments, Result> {
	let argumentMatcher: ArgumentMatcher<Arguments>
	let register: (AsyncMethodInvocation<Arguments, Result>) -> Void
	
	var invocation: AsyncMethodInvocation<Arguments, Result>?
	
	init(
		argumentMatcher: @escaping ArgumentMatcher<Arguments>,
		register: @escaping (AsyncMethodInvocation<Arguments, Result>) -> Void
	) {
		self.argumentMatcher = argumentMatcher
		self.register = register
	}
}

public extension AsyncMethodInvocationBuilder {
	@discardableResult
	func thenReturn(_ evaluation: @escaping (Arguments) -> Result) -> Self {
		if let invocation = invocation {
			invocation.append(evaluation)
		} else {
			let invocation = AsyncMethodInvocation(
				matcher: argumentMatcher,
				evaluation: evaluation
			)
			self.invocation = invocation
			register(invocation)
		}
		return self
	}
	
	@discardableResult
	func thenReturn(_ value: Result) -> Self {
		thenReturn { _ in value }
	}
}

public extension AsyncMethodInvocationBuilder where Result == Void {
	@discardableResult
	func thenReturn() -> Self {
		thenReturn(())
	}
}
