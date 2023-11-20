//
//  ThrowsMethodInvocationBuilder.swift
//
//
//  Created by Alexandr Zalutskiy on 20/10/2023.
//

public final class ThrowsMethodInvocationBuilder<Arguments, Result> {
	let argumentMatcher: ArgumentMatcher<Arguments>
	let register: (ThrowsMethodInvocation<Arguments, Result>) -> Void
	
	var invocation: ThrowsMethodInvocation<Arguments, Result>?
	
	init(
		argumentMatcher: @escaping ArgumentMatcher<Arguments>,
		register: @escaping (ThrowsMethodInvocation<Arguments, Result>) -> Void
	) {
		self.argumentMatcher = argumentMatcher
		self.register = register
	}
}

extension ThrowsMethodInvocationBuilder {
	@discardableResult
	func thenReturn(_ evaluation: @escaping (Arguments) throws -> Result) -> Self {
		if let invocation = invocation {
			invocation.append(evaluation)
		} else {
			let invocation = ThrowsMethodInvocation(
				matcher: argumentMatcher,
				evaluation: evaluation
			)
			self.invocation = invocation
			register(invocation)
		}
		return self
	}
}

public extension ThrowsMethodInvocationBuilder {
	@discardableResult
	func thenReturn(_ value: Result) -> Self {
		thenReturn { _ in value }
	}
	
	@discardableResult
	func thenThrow(_ error: Error) -> Self {
		thenReturn { _ in throw error }
	}
}

public extension ThrowsMethodInvocationBuilder where Result == Void {
	@discardableResult
	func thenReturn() -> Self {
		thenReturn(())
	}
}

public extension ThrowsMethodInvocationBuilder {
	@discardableResult
	func thenAnswer(_ evaluation: @escaping (Arguments) throws -> Result) -> Self {
		thenReturn(evaluation)
	}
	
	@discardableResult
	func thenAnswer<A, B>(_ evaluation: @escaping (A, B) throws -> Result) -> Self where Arguments == (A, B) {
		thenReturn {
			try evaluation($0.0, $0.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C>(_ evaluation: @escaping (A, B, C) throws -> Result) -> Self where Arguments == (A, (B, C)) {
		thenReturn {
			try evaluation($0.0, $0.1.0, $0.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D>(_ evaluation: @escaping (A, B, C, D) throws -> Result) -> Self where Arguments == (A, (B, (C, D))) {
		thenReturn {
			try evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E>(_ evaluation: @escaping (A, B, C, D, E) throws -> Result) -> Self where Arguments == (A, (B, (C, (D, E)))) {
		thenReturn {
			try evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F>(_ evaluation: @escaping (A, B, C, D, E, F) throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, F))))) {
		thenReturn {
			try evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G>(_ evaluation: @escaping (A, B, C, D, E, F, G) throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, G)))))) {
		thenReturn {
			try evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H>(_ evaluation: @escaping (A, B, C, D, E, F, G, H) throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, H))))))) {
		thenReturn {
			try evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I) throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, I)))))))) {
		thenReturn {
			try evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J) throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, J))))))))) {
		thenReturn {
			try evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K) throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, K)))))))))) {
		thenReturn {
			try evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L) throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, L))))))))))) {
		thenReturn {
			try evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M) throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, M)))))))))))) {
		thenReturn {
			try evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M, N>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N) throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, (M, N))))))))))))) {
		thenReturn {
			try evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O) throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, (M, (N, O)))))))))))))) {
		thenReturn {
			try evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P) throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, (M, (N, (O, P))))))))))))))) {
		thenReturn {
			try evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q) throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, (M, (N, (O, (P, Q)))))))))))))))) {
		thenReturn {
			try evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
	
	@discardableResult
	func thenAnswer<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R>(_ evaluation: @escaping (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R) throws -> Result) -> Self where Arguments == (A, (B, (C, (D, (E, (F, (G, (H, (I, (J, (K, (L, (M, (N, (O, (P, (Q, R))))))))))))))))) {
		thenReturn {
			try evaluation($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1.0, $0.1.1.1.1.1.0, $0.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.0, $0.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1)
		}
	}
}

