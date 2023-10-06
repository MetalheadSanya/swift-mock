public struct MethodCall<Arguments> {
	let arguments: Arguments
	
	public init(arguments: Arguments) {
		self.arguments = arguments
	}
	
	public static func verify(
		in container: [MethodCall<Arguments>],
		matcher match: ArgumentMatcher<Arguments>,
		times: TimesMatcher,
		type: String,
		function: String = #function
	) {
		let callCount = container.filter { match($0.arguments) }.count
		guard times(callCount) else {
			testFailureReport("\(type).\(function): incorrect calls count: \(callCount)")
			return
		}
	}
}
