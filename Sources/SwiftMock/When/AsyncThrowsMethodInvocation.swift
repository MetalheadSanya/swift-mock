//#if canImport(XCTest)
//import XCTest
//#endif

public final class AsyncThrowsMethodInvocation<Arguments, Result> {
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
	
	func eval(_ arguments: Arguments) async throws -> Result {
		defer {
			if current < evaluations.count - 1 {
				current += 1
			}
		}
		let evaluation = evaluations[current]
		return try await evaluation(arguments)
	}
}
