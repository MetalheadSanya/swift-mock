//
//  InOrderTests.swift
//
//
//  Created by Alexandr Zalutskiy on 17/10/2023.
//

import Foundation
import SwiftMock
import SwiftMockConfiguration
import XCTest

final class InOrderTests: XCTestCase {
	override func setUp() {
		super.setUp()
		continueAfterFailure = false
		SwiftMockConfiguration.setUp()
	}
	
	override func tearDown() {
		SwiftMockConfiguration.tearDown()
		super.tearDown()
	}
	
	func testInOrder() throws {
		let mock = ThrowsProtocolMock()
		
		when(mock.$call()).thenReturn(6)
		when(mock.$call0()).thenReturn()
		
		_ = try mock.call()
		try mock.call0()
		
		let inOrder = inOrder(mock)
		
		inOrder.verify(mock).call()
		inOrder.verify(mock).call0()
	}
	
	#if !os(Linux)
	func testInOrderFailure() throws {
		let mock = ThrowsProtocolMock()
		
		when(mock.$call()).thenReturn(6)
		when(mock.$call0()).thenReturn()
		
		_ = try mock.call()
		try mock.call0()
		
		XCTExpectFailure {
			let inOrder = inOrder(mock)

			inOrder.verify(mock).call0()
			inOrder.verify(mock).call()
		}
		
	}
	#endif
	
	func testTwoMockObject() throws {
		let mock0 = ThrowsProtocolMock()
		let mock1 = SimpleProtocolMock()
		
		when(mock0.$call()).thenReturn(6)
		when(mock0.$call0()).thenReturn()
		
		when(mock1.$call()).thenReturn(4)
		
		_ = try mock0.call()
		_ = mock1.call()
		try mock0.call0()
		
		let inOrder = inOrder(mock0, mock1)
		
		inOrder.verify(mock0).call()
		inOrder.verify(mock1).call()
		inOrder.verify(mock0).call0()
	}
	
	func testWithDistanceBetweenCalls() throws {
		let mock0 = ThrowsProtocolMock()
		let mock1 = SimpleProtocolMock()
		
		when(mock0.$call()).thenReturn(6)
		when(mock0.$call0()).thenReturn()
		
		when(mock1.$call()).thenReturn(4)
		
		_ = try mock0.call()
		_ = mock1.call()
		_ = mock1.call()
		_ = mock1.call()
		_ = try mock0.call()
		try mock0.call0()
		
		let inOrder = inOrder(mock0, mock1)
		
		inOrder.verify(mock0, times: times(2)).call()
		inOrder.verify(mock0).call0()
	}
	
	func testGenericWithOneArgmuent() throws {
		let mock = GenericMethodProtocolMock()
		
		when(mock.$oneParameter(parameter: any(type: Int.self)))
			.thenReturn(6)
		when(mock.$oneParameter(parameter: any(type: String.self)))
			.thenReturn(6)
		
		_ = mock.oneParameter(parameter: 6)
		_ = mock.oneParameter(parameter: "6")
		
		let inOrder = inOrder(mock)
		
		inOrder.verify(mock).oneParameter(parameter: any(type: Int.self))
		inOrder.verify(mock).oneParameter(parameter: any(type: String.self))
		
		#if !os(Linux)
		_ = mock.oneParameter(parameter: 6)
		_ = mock.oneParameter(parameter: "6")
		
		XCTExpectFailure {
			inOrder.verify(mock).oneParameter(parameter: any(type: String.self))
			inOrder.verify(mock).oneParameter(parameter: any(type: Int.self))
		}
		
		#endif
		
	}
}
