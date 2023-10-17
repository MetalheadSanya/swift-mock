//
//  InOrder.swift
//
//
//  Created by Alexandr Zalutskiy on 12/10/2023.
//

public struct InOrder {
	private let mocks: [AnyObject]
	
	private let container: InOrderContainer
	
	init(_ mocks: [AnyObject]) {
		self.mocks = mocks
		self.container = InOrderContainer()
	}
	
	public func verify<Mock: AnyObject & Verifiable>(_ mock: Mock, times: @escaping TimesMatcher = times(1)) -> Mock.Verify {
		guard mocks.contains(where: { $0 === mock }) else {
			testFailureReport("")
			fatalError("")
		}
		
		return Mock.Verify(mock: mock, container: container, times: times)
	}
}
