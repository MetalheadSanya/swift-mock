//
//  File.swift
//  
//
//  Created by Alexandr Zalutskiy on 13/10/2023.
//

public protocol CallContainer {
	
	func append<T>(mock: AnyObject, call: MethodCall<T>, function: String)
	func verify<T>(
		mock: AnyObject,
		matcher: ArgumentMatcher<T>,
		times: TimesMatcher,
		type: String,
		function: String
	)
}
