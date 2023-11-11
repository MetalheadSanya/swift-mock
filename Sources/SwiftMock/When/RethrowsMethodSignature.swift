//
//  RethrowsMethodSignature.swift
//
//
//  Created by Alexandr Zalutskiy on 20/10/2023.
//

public struct RethrowsMethodSignature<Arguments, Result> {
	let argumentMatcher: ArgumentMatcher<Arguments>
	let register: (RethrowsMethodInvocation<Arguments, Result>) -> Void
	
	public init(
		argumentMatcher: @escaping ArgumentMatcher<Arguments>,
		register: @escaping (RethrowsMethodInvocation<Arguments, Result>) -> Void
	) {
		self.argumentMatcher = argumentMatcher
		self.register = register
	}
}
