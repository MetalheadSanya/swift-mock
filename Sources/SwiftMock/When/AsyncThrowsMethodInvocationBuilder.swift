public final class AsyncThrowsMethodInvocationBuilder<Arguments, Result> {
	let argumentMatcher: ArgumentMatcher<Arguments>
	let register: (AsyncThrowsMethodInvocation<Arguments, Result>) -> Void
	
	var invocation: AsyncThrowsMethodInvocation<Arguments, Result>?
	
	init(
		argumentMatcher: @escaping ArgumentMatcher<Arguments>,
		register: @escaping (AsyncThrowsMethodInvocation<Arguments, Result>) -> Void
	) {
		self.argumentMatcher = argumentMatcher
		self.register = register
	}
}

extension AsyncThrowsMethodInvocationBuilder {
	@discardableResult
	func thenReturn(_ evaluation: @escaping (Arguments) async throws -> Result) -> Self {
		if let invocation = invocation {
			invocation.append(evaluation)
		} else {
			let invocation = AsyncThrowsMethodInvocation(
				matcher: argumentMatcher,
				evaluation: evaluation
			)
			self.invocation = invocation
			register(invocation)
		}
		return self
	}
}
	
public extension AsyncThrowsMethodInvocationBuilder {
	@discardableResult
	func thenReturn(_ value: Result) -> Self {
		thenReturn { _ in value }
	}
	
	@discardableResult
	func thenThrow(_ error: Error) -> Self {
		thenReturn { _ in throw error }
	}
}

public extension AsyncThrowsMethodInvocationBuilder where Result == Void {
	@discardableResult
	func thenReturn() -> Self {
		thenReturn(())
	}
}

public extension AsyncThrowsMethodInvocationBuilder {
	@discardableResult
	func thenAnswer(_ evaluation: @escaping (Arguments) async throws -> Result) -> Self {
		thenReturn(evaluation)
	}
	
	@discardableResult
	func thenAnswer<A, B>(_ evaluation: @escaping (A, B) async throws -> Result) -> Self where Arguments == (A, B) {
		thenReturn {
			try await evaluation($0.0, $0.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C>(_ evaluation: @escaping (A, B, C) async throws -> Result) -> Self where Arguments == (A, (B, C)) {
		thenReturn {
			try await evaluation($0.0, $0.1.0, $0.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D>(_ evaluation: @escaping (A, B, C, D) async throws -> Result) -> Self where Arguments == (A, (B, (C, D))) {
		thenReturn {
			try await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E>(_ evaluation: @escaping (A, B, C, D, E) async throws -> Result) -> Self where Arguments == (A, (B, (C, (D, E)))) {
		thenReturn {
			try await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F>(_ evaluation: @escaping (A, B, C, D, E, F) async throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, F))))) {
		thenReturn {
			try await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G>(_ evaluation: @escaping (A, B, C, D, E, F, G) async throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, G)))))) {
		thenReturn {
			try await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H>(_ evaluation: @escaping (A, B, C, D, E, F, G, H) async throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, H))))))) {
		thenReturn {
			try await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I) async throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, I)))))))) {
		thenReturn {
			try await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J) async throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, J))))))))) {
		thenReturn {
			try await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K) async throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, K)))))))))) {
		thenReturn {
			try await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L) async throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, L))))))))))) {
		thenReturn {
			try await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M) async throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, M)))))))))))) {
		thenReturn {
			try await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N) async throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, (M, N))))))))))))) {
		thenReturn {
			try await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O) async throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, (M, (N, O)))))))))))))) {
		thenReturn {
			try await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P) async throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, (M, (N, (O, P))))))))))))))) {
		thenReturn {
			try await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q) async throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, (M, (N, (O, (P, Q)))))))))))))))) {
		thenReturn {
			try await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R) async throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, (M, (N, (O, (P, (Q, R))))))))))))))))) {
		thenReturn {
			try await evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
}

