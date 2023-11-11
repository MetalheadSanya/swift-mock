//
//  AsyncRethrowsMethodInvocation.swift
//
//
//  Created by Alexandr Zalutskiy on 11/11/2023.
//

public final class AsyncRethrowsMethodInvocation<Arguments, Result> {
	let match: ArgumentMatcher<Arguments>
	private var evaluations: [(Arguments) async throws -> Result]
	private var current = 0
	
	public init(
		matcher: @escaping ArgumentMatcher<Arguments>,
		evaluation: @escaping (Arguments) async throws -> Result
	) {
		self.match = matcher
		self.evaluations = [evaluation]
	}
	
	func append(_ evaluation: @escaping (Arguments) async throws -> Result) {
		evaluations.append(evaluation)
	}
	
	func eval(_ arguments: Arguments, _ f: (Error) throws -> Void) async rethrows -> Result {
		defer {
			if current < evaluations.count - 1 {
				current += 1
			}
		}
		let evaluation = evaluations[current]
		
		var result: Result?
		var error: Error?
		
		do {
			result = try await evaluation(arguments)
		} catch let e {
			error = e
		}
		
		if let error = error {
			try f(error)
		}
		
		return result!
	}
}

