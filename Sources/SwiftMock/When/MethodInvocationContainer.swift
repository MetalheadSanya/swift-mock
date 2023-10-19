//
//  MethodInvocationContainer.swift
//
//
//  Created by Alexandr Zalutskiy on 19/10/2023.
//

public final class MethodInvocationContainer {
	var invocations: [Any] = []
	
	public init() { }
	
	public func append<Arguments, Result>(_ invocation: MethodInvocation<Arguments, Result>) {
		invocations.append(invocation)
	}
	
	public func find<Arguments, Result>(
		with arguments: Arguments,
		type: String,
		function: String
	) -> Result {
		let invocations = invocations.compactMap {
			$0 as? MethodInvocation<Arguments, Result>
		}
		guard let invocation = invocations.last(where: { invocation in
			invocation.match(arguments)
		}) else {
			testFailureReport("\(type).\(function): could not find invocation for arguments: \(arguments)")
			fatalError("\(type).\(function): could not find invocation for arguments: \(arguments)")
		}
		return invocation.eval(arguments)
	}
}
