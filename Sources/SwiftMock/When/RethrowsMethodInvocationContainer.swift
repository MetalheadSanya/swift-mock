//
//  RethrowsMethodInvocationContainer.swift
//
//
//  Created by Alexandr Zalutskiy on 11/11/2023.
//

public final class RethrowsMethodInvocationContainer {
	var invocations: [Any] = []
	
	public init() { }
	
	public func append<Arguments, Result>(_ invocation: RethrowsMethodInvocation<Arguments, Result>) {
		invocations.append(invocation)
	}
	
	public func find<Arguments, Result>(
		with arguments: Arguments,
		type: String,
		function: String,
		_ f: (Error) throws -> Void
	) rethrows -> Result {
		let invocations = invocations.compactMap {
			$0 as? RethrowsMethodInvocation<Arguments, Result>
		}
		guard let invocation = invocations.last(where: { invocation in
			invocation.match(arguments)
		}) else {
			testFailureReport("\(type).\(function): could not find invocation for arguments: \(arguments)", #file, #line)
			fatalError("\(type).\(function): could not find invocation for arguments: \(arguments)")
		}
		return try invocation.eval(arguments, f)
	}
}

