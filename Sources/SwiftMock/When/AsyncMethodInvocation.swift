//#if canImport(XCTest)
//import XCTest
//#endif

public final class AsyncMethodInvocation<Arguments, Result> {
	private let match: ArgumentMatcher<Arguments>
	private var evaluations: [(Arguments) async -> Result]
	private var current = 0
	
	public init(
		matcher: @escaping ArgumentMatcher<Arguments>,
		evaluation: @escaping (Arguments) -> Result
	) {
		self.match = matcher
		self.evaluations = [evaluation]
	}
	
	func append(_ evaluation: @escaping (Arguments) async -> Result) {
		evaluations.append(evaluation)
	}
	
	func eval(_ arguments: Arguments) async -> Result {
		defer {
			if current < evaluations.count - 1 {
				current += 1
			}
		}
		let evaluation = evaluations[current]
		return await evaluation(arguments)
	}
	
	public static func find(
		in container: [AsyncMethodInvocation<Arguments, Result>],
		with arguments: Arguments,
		type: String,
		function: String = #function
	) async -> Result {
		guard let invocation = container.last(where: { invocation in
			invocation.match(arguments)
		}) else {
			//			#if canImport(XCTest)
			//			XCTFail("\(type).\(function): could not find invocation for arguments: \(criteria)")
			//			#endif
			fatalError("\(type).\(function): could not find invocation for arguments: \(arguments)")
		}
		return await invocation.eval(arguments)
	}
}

