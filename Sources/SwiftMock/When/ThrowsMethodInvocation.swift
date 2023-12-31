//
//  ThrowsMethodInvocation.swift
//
//
//  Created by Alexandr Zalutskiy on 20/10/2023.
//

public final class ThrowsMethodInvocation<Arguments, Result> {
	let match: ArgumentMatcher<Arguments>
	private var evaluations: [(Arguments) throws -> Result]
	private var current = 0
	
	public init(
		matcher: @escaping ArgumentMatcher<Arguments>,
		evaluation: @escaping (Arguments) throws -> Result
	) {
		self.match = matcher
		self.evaluations = [evaluation]
	}
	
	func append(_ evaluation: @escaping (Arguments) throws -> Result) {
		evaluations.append(evaluation)
	}
	
	func eval(_ arguments: Arguments) throws -> Result {
		defer {
			if current < evaluations.count - 1 {
				current += 1
			}
		}
		let evaluation = evaluations[current]
		return try evaluation(arguments)
	}
}
