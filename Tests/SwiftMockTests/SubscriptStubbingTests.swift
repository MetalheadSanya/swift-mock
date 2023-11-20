//
//  SubscriptStubbingTests.swift
//
//
//  Created by Alexandr Zalutskiy on 23/10/2023.
//

import SwiftMock
import SwiftMockConfiguration
import XCTest

@Mock
protocol SubscriptProtocol {
	subscript(_ value: Int) -> String  { get set }
	subscript(_ value0: Int, value1: Int) -> String { get }
	subscript<T: Equatable>(value: T) -> T { get set }
}

final class SubscriptStubbingTests: XCTestCase {
	override func setUp() {
		continueAfterFailure = false
		SwiftMockConfiguration.setUp()
	}
	
	override func tearDown() {
		SwiftMockConfiguration.tearDown()
		super.tearDown()
	}
	
	func testOneArgumentGet() throws {
		let mock = SubscriptProtocolMock()
		
		let expected = "5"
		
		when(mock.$subscriptGetter())
			.thenReturn(expected)
		
		let answer = mock[5]
		
		XCTAssertEqual(expected, answer)
		
		verify(mock).subscriptGetter(eq(5))
	}
	
	func testOneArgumentSet() throws {
		let mock = SubscriptProtocolMock()
		
		let expected = "5"
		
		when(mock.$subscriptSetter())
			.thenReturn()
		
		mock[5] = expected
		
		verify(mock).subscriptSetter(eq(5), newValue: eq(expected))
	}
	
	func testTwoArgumentGet() throws {
		let mock = SubscriptProtocolMock()
		
		let expected = "5"
		
		when(mock.$subscriptGetter(any(), value1: any()))
			.thenReturn(expected)
		
		let answer = mock[5, 8]
		
		XCTAssertEqual(expected, answer)
		
		verify(mock).subscriptGetter(eq(5), value1: eq(8))
	}
	
	func testGenericAtgumentGet() {
		let mock = SubscriptProtocolMock()
		
		let expected = "5"
		
		when(mock.$subscriptGetter(value: any(type: String.self)))
			.thenReturn(expected)
		
		let answer = mock["test"]
		
		XCTAssertEqual(expected, answer)
		
		verify(mock).subscriptGetter(value: eq("test"))
	}
	
	func testGenericAtgumentSet() {
		let mock = SubscriptProtocolMock()
		
		let expected = "5"
		
		when(mock.$subscriptSetter(value: any(type: String.self), newValue: any(type: String.self)))
			.thenReturn()
		
		mock["test"] = expected
		
		verify(mock).subscriptSetter(value: eq("test"), newValue: eq(expected))
	}
}
