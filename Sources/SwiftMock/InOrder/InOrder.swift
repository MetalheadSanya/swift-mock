//
//  InOrder.swift
//
//
//  Created by Alexandr Zalutskiy on 12/10/2023.
//

/// Struct that allows you to check that mock methods were called in a certain order.
public struct InOrder {
	private let mocks: [AnyObject]
	
	private let container: InOrderContainer
	
	init(_ mocks: [AnyObject]) {
		self.mocks = mocks
		self.container = InOrderContainer()
	}
	
	/// Create `Verify` struct that allows you to check next method on specific mock object.
	///
	/// - Parameters:
	/// 	- mock: Mock the object whose method call we are checking.
	///		- times: How many calls do we want to check.
	///
	///	- Returns: `Verify` structure specific to the passed mock object.
	///
	///	- Note: You don't have to verify all interactions one-by-one but only those that you are interested in testing in order.
	public func verify<Mock: AnyObject & Verifiable>(_ mock: Mock, times: @escaping TimesMatcher = times(1), file: StaticString = #filePath, line: UInt = #line) -> Mock.Verify {
		guard mocks.contains(where: { $0 === mock }) else {
			testFailureReport("The 'InOrder' doesn't contains such a mock", file, line)
			fatalError("The 'InOrder' doesn't contains such a mock", file: (file), line: line)
		}
		
		return Mock.Verify(mock: mock, container: container, times: times)
	}
}
