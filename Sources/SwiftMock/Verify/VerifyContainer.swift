//
//  MethodCallContainer.swift
//
//
//  Created by Alexandr Zalutskiy on 12/10/2023.
//

import Foundation

public class VerifyContainer: CallContainer {
	var calls: [Any] = []
	var functions: [String] = []
	var isVerified: [Bool] = []
	
	public init() { }
	
	public func append<T>(mock: AnyObject, call: MethodCall<T>, function: String) {
		calls.append(call)
		functions.append(function)
		isVerified.append(false)
	}
	
	public func verify<T>(
		mock: AnyObject,
		matcher match: ArgumentMatcher<T>,
		times: (Int) -> Bool,
		type: String,
		function: String
	) {
		var callCount = 0
		var indexes: [Array.Index] = []
		for index in calls.startIndex..<calls.endIndex {
			guard !isVerified[index] else {
				continue
			}
			guard functions[index] == function else {
				continue
			}
			guard let call = calls[index] as? MethodCall<T> else {
				continue
			}
			guard match(call.arguments) else {
				continue
			}
			indexes.append(index)
			callCount += 1
		}
		guard times(callCount) else {
			testFailureReport("\(type).\(function): incorrect calls count: \(callCount)")
			return
		}
		for index in indexes {
			isVerified[index] = true
		}
	}
}
