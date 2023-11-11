//
//  AsyncRethrowsMethodInvocationBuilder.swift
//
//
//  Created by Alexandr Zalutskiy on 20/10/2023.
//

public final class AsyncRethrowsMethodInvocationBuilder<Arguments, Result> {
	let argumentMatcher: ArgumentMatcher<Arguments>
	let register: (AsyncRethrowsMethodInvocation<Arguments, Result>) -> Void
	
	var invocation: AsyncRethrowsMethodInvocation<Arguments, Result>?
	
	init(
		argumentMatcher: @escaping ArgumentMatcher<Arguments>,
		register: @escaping (AsyncRethrowsMethodInvocation<Arguments, Result>) -> Void
	) {
		self.argumentMatcher = argumentMatcher
		self.register = register
	}
}

public extension AsyncRethrowsMethodInvocationBuilder {
	@discardableResult
	func thenReturn(_ evaluation: @escaping (Arguments) async throws -> Result) -> Self {
		if let invocation = invocation {
			invocation.append(evaluation)
		} else {
			let invocation = AsyncRethrowsMethodInvocation(
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
	
	@discardableResult
	func thenThrow(_ error: Error) -> Self {
		thenReturn { _ in throw error }
	}
}

public extension AsyncRethrowsMethodInvocationBuilder where Result == Void {
	@discardableResult
	func thenReturn() -> Self {
		thenReturn(())
	}
}
