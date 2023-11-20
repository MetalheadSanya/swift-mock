//
//  ThrowsMethodInvocationContainer.swift
//
//
//  Created by Alexandr Zalutskiy on 19/10/2023.
//

public final class ThrowsMethodInvocationContainer {
	var invocations: [Any] = []
	
	public init() { }
	
	public func append<Arguments, Result>(_ invocation: ThrowsMethodInvocation<Arguments, Result>) {
		invocations.append(invocation)
	}
	
	public func find<Arguments, Result>(
		with arguments: Arguments,
		type: String,
		function: String
	) throws -> Result {
		let invocations = invocations.compactMap {
			$0 as? ThrowsMethodInvocation<Arguments, Result>
		}
		guard let invocation = invocations.last(where: { invocation in
			invocation.match(arguments)
		}) else {
			testFailureReport("\(type).\(function): could not find invocation for arguments: \(arguments)", #file, #line)
			fatalError("\(type).\(function): could not find invocation for arguments: \(arguments)")
		}
		return try invocation.eval(arguments)
	}
}
