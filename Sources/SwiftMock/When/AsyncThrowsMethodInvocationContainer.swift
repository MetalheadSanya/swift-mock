//
//  AsyncThrowsMethodInvocationContainer.swift
//
//
//  Created by Alexandr Zalutskiy on 19/10/2023.
//

public final class AsyncThrowsMethodInvocationContainer {
	var invocations: [Any] = []
	
	public init() { }
	
	public func append<Arguments, Result>(_ invocation: AsyncThrowsMethodInvocation<Arguments, Result>) {
		invocations.append(invocation)
	}
	
	public func find<Arguments, Result>(
		with arguments: Arguments,
		type: String,
		function: String
	) async throws -> Result {
		let invocations = invocations.compactMap {
			$0 as? AsyncThrowsMethodInvocation<Arguments, Result>
		}
		guard let invocation = invocations.last(where: { invocation in
			invocation.match(arguments)
		}) else {
			testFailureReport("\(type).\(function): could not find invocation for arguments: \(arguments)")
			fatalError("\(type).\(function): could not find invocation for arguments: \(arguments)")
		}
		return try await invocation.eval(arguments)
	}
}
