//#if canImport(XCTest)
//import XCTest
//#endif

public final class MethodInvocation<Arguments, Result> {
	let match: ArgumentMatcher<Arguments>
	private var evaluations: [(Arguments) -> Result]
	private var current = 0
	
	public init(
		matcher: @escaping ArgumentMatcher<Arguments>,
		evaluation: @escaping (Arguments) -> Result
	) {
		self.match = matcher
		self.evaluations = [evaluation]
	}
	
	func append(_ evaluation: @escaping (Arguments) -> Result) {
		evaluations.append(evaluation)
	}
	
	func eval(_ arguments: Arguments) -> Result {
		defer {
			if current < evaluations.count - 1 {
				current += 1
			}
		}
		let evaluation = evaluations[current]
		return evaluation(arguments)
	}
}
