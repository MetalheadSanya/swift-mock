//
//  RethrowsMethodInvocationBuilder.swift
//
//
//  Created by Alexandr Zalutskiy on 20/10/2023.
//

public final class RethrowsMethodInvocationBuilder<Arguments, Result> {
	let argumentMatcher: ArgumentMatcher<Arguments>
	let register: (RethrowsMethodInvocation<Arguments, Result>) -> Void
	
	var invocation: RethrowsMethodInvocation<Arguments, Result>?
	
	init(
		argumentMatcher: @escaping ArgumentMatcher<Arguments>,
		register: @escaping (RethrowsMethodInvocation<Arguments, Result>) -> Void
	) {
		self.argumentMatcher = argumentMatcher
		self.register = register
	}
}

public extension RethrowsMethodInvocationBuilder {
	@discardableResult
	func thenReturn(_ evaluation: @escaping (Arguments) throws -> Result) -> Self {
		if let invocation = invocation {
			invocation.append(evaluation)
		} else {
			let invocation = RethrowsMethodInvocation(
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

public extension RethrowsMethodInvocationBuilder where Result == Void {
	@discardableResult
	func thenReturn() -> Self {
		thenReturn(())
	}
}
