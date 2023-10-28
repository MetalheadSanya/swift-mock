//
//  AssociatedTypeStubbingTests.swift
//  
//
//  Created by Alexandr Zalutskiy on 28/10/2023.
//

import Foundation
import SwiftMock
import XCTest

@Mock
protocol AssociatedTypeProtocol {
	associatedtype A
	associatedtype B
	
	func testArguments(a: A, b: B)
	func testReturn() -> A
	
	var testProperty: B { get set }
	
	subscript(_ value: A) -> B { get }
}

final class AssociatedTypeStubbingTests: XCTestCase {
	override func setUp() {
		super.setUp()
		continueAfterFailure = false
		testFailureReport = { message in
			XCTFail(message)
		}
	}
	
	override func tearDown() {
		cleanUpMock()
		super.tearDown()
	}
	
	func testArguments() throws {
		let mock = AssociatedTypeProtocolMock<Int, String>()
		
		when(mock.$testArguments())
			.thenReturn()
		
		mock.testArguments(a: 8, b: "6")
		
		verify(mock).testArguments(a: eq(8), b: eq("6"))
	}
	
	func testReturn() throws {
		let mock = AssociatedTypeProtocolMock<Int, String>()
		
		let expexted = 8
		
		when(mock.$testReturn())
			.thenReturn(expexted)
		
		let actual = mock.testReturn()
		
		XCTAssertEqual(expexted, actual)
		
		verify(mock).testReturn()
	}
	
	func testProperty() throws {
		let mock = AssociatedTypeProtocolMock<Int, String>()
		
		let expectedGet = "Get"
		let expectedSet = "Set"
		
		when(mock.$testPropertyGetter())
			.thenReturn(expectedGet)
		when(mock.$testPropertySetter(eq(expectedSet)))
			.thenReturn()
		
		let actualGet = mock.testProperty
		
		mock.testProperty = expectedSet
		
		XCTAssertEqual(expectedGet, actualGet)
		
		verify(mock).testPropertyGetter()
		verify(mock).testPropertySetter(eq(expectedSet))
	}
	
	func testSubscript() throws {
		let mock = AssociatedTypeProtocolMock<Int, String>()
		
		let expectedGet = "Get"
		let expextedIndex = 6
		
		when(mock.$subscriptGetter(eq(expextedIndex)))
			.thenReturn(expectedGet)
		
		let actualGet = mock[expextedIndex]
		
		XCTAssertEqual(expectedGet, actualGet)
		
		verify(mock).subscriptGetter(eq(expextedIndex))
	}
}
