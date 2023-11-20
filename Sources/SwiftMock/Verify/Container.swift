//
//  File.swift
//  
//
//  Created by Alexandr Zalutskiy on 13/10/2023.
//

public protocol CallContainer {
	func verify<T>(
		mock: AnyObject,
		matcher: ArgumentMatcher<T>,
		times: TimesMatcher,
		type: String,
		function: String,
		file: StaticString,
		line: UInt
	)
}
