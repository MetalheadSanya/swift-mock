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

extension AsyncMethodInvocationBuilder {
	@discardableResult
	func thenReturn(_ evaluation: @escaping (Arguments) async -> Result) -> Self {
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
}

public extension AsyncMethodInvocationBuilder {
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

public extension AsyncMethodInvocationBuilder {
	@discardableResult
	func thenAnswer(_ evaluation: @escaping (Arguments) async -> Result) -> Self {
		thenReturn(evaluation)
	}
	
	@discardableResult
	func thenAnswer<A, B>(_ evaluation: @escaping (A, B) async -> Result) -> Self where Arguments == (A, B) {
		thenReturn {
			await evaluation($0.0, $0.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C>(_ evaluation: @escaping (A, B, C) async -> Result) -> Self where Arguments == (A, (B, C)) {
		thenReturn {
			await evaluation($0.0, $0.1.0, $0.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D>(_ evaluation: @escaping (A, B, C, D) async -> Result) -> Self where Arguments == (A, (B, (C, D))) {
		thenReturn {
			await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E>(_ evaluation: @escaping (A, B, C, D, E) async -> Result) -> Self where Arguments == (A, (B, (C, (D, E)))) {
		thenReturn {
			await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F>(_ evaluation: @escaping (A, B, C, D, E, F) async -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, F))))) {
		thenReturn {
			await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G>(_ evaluation: @escaping (A, B, C, D, E, F, G) async -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, G)))))) {
		thenReturn {
			await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H>(_ evaluation: @escaping (A, B, C, D, E, F, G, H) async -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, H))))))) {
		thenReturn {
			await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I) async -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, I)))))))) {
		thenReturn {
			await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J) async -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, J))))))))) {
		thenReturn {
			await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K) async -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, K)))))))))) {
		thenReturn {
			await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L) async -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, L))))))))))) {
		thenReturn {
			await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M) async -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, M)))))))))))) {
		thenReturn {
			await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N) async -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, (M, N))))))))))))) {
		thenReturn {
			await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O) async -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, (M, (N, O)))))))))))))) {
		thenReturn {
			await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P) async -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, (M, (N, (O, P))))))))))))))) {
		thenReturn {
			await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q) async -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, (M, (N, (O, (P, Q)))))))))))))))) {
		thenReturn {
			await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R) async -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, (M, (N, (O, (P, (Q, R))))))))))))))))) {
		thenReturn {
			await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
}
