//
//  AsyncRethrowsMethodSignature.swift
//
//
//  Created by Alexandr Zalutskiy on 20/10/2023.
//

public struct AsyncRethrowsMethodSignature<Arguments, Result> {
	let argumentMatcher: ArgumentMatcher<Arguments>
	let register: (AsyncRethrowsMethodInvocation<Arguments, Result>) -> Void
	
	public init(
		argumentMatcher: @escaping ArgumentMatcher<Arguments>,
		register: @escaping (AsyncRethrowsMethodInvocation<Arguments, Result>) -> Void
	) {
		self.argumentMatcher = argumentMatcher
		self.register = register
	}
}
