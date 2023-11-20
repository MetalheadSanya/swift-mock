public final class MethodInvocationBuilder<Arguments, Result> {
	let argumentMatcher: ArgumentMatcher<Arguments>
	let register: (MethodInvocation<Arguments, Result>) -> Void
	
	var invocation: MethodInvocation<Arguments, Result>?
	
	init(
		argumentMatcher: @escaping ArgumentMatcher<Arguments>,
		register: @escaping (MethodInvocation<Arguments, Result>) -> Void
	) {
		self.argumentMatcher = argumentMatcher
		self.register = register
	}
}

extension MethodInvocationBuilder {
	@discardableResult
	func thenReturn(_ evaluation: @escaping (Arguments) -> Result) -> Self {
		if let invocation = invocation {
			invocation.append(evaluation)
		} else {
			let invocation = MethodInvocation(
				matcher: argumentMatcher,
				evaluation: evaluation
			)
			self.invocation = invocation
			register(invocation)
		}
		return self
	}
}

public extension MethodInvocationBuilder {
	@discardableResult
	func thenReturn(_ value: Result) -> Self {
		thenReturn { _ in value }
	}
}

public extension MethodInvocationBuilder where Result == Void {
	@discardableResult
	func thenReturn() -> Self {
		thenReturn(())
	}
}

public extension MethodInvocationBuilder {
	@discardableResult
	func thenAnswer(_ evaluation: @escaping (Arguments) -> Result) -> Self {
		thenReturn(evaluation)
	}
	
	@discardableResult
	func thenAnswer<A, B>(_ evaluation: @escaping (A, B) -> Result) -> Self where Arguments == (A, B) {
		thenReturn {
			evaluation($0.0, $0.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C>(_ evaluation: @escaping (A, B, C) -> Result) -> Self where Arguments == (A, (B, C)) {
		thenReturn {
			evaluation($0.0, $0.1.0, $0.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D>(_ evaluation: @escaping (A, B, C, D) -> Result) -> Self where Arguments == (A, (B, (C, D))) {
		thenReturn {
			evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E>(_ evaluation: @escaping (A, B, C, D, E) -> Result) -> Self where Arguments == (A, (B, (C, (D, E)))) {
		thenReturn {
			evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F>(_ evaluation: @escaping (A, B, C, D, E, F) -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, F))))) {
		thenReturn {
			evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G>(_ evaluation: @escaping (A, B, C, D, E, F, G) -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, G)))))) {
		thenReturn {
			evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H>(_ evaluation: @escaping (A, B, C, D, E, F, G, H) -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, H))))))) {
		thenReturn {
			evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I) -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, I)))))))) {
		thenReturn {
			evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J) -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, J))))))))) {
		thenReturn {
			evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K) -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, K)))))))))) {
		thenReturn {
			evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L) -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, L))))))))))) {
		thenReturn {
			evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M) -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, M)))))))))))) {
		thenReturn {
			evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N) -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, (M, N))))))))))))) {
		thenReturn {
			evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O) -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, (M, (N, O)))))))))))))) {
		thenReturn {
			evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P) -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, (M, (N, (O, P))))))))))))))) {
		thenReturn {
			evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q) -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, (M, (N, (O, (P, Q)))))))))))))))) {
		thenReturn {
			evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R) -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, (M, (N, (O, (P, (Q, R))))))))))))))))) {
		thenReturn {
			evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
}

