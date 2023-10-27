import SwiftMock
import XCTest

@Mock
protocol ArgumentMatcherTestProtocol {
	func call(argument0: Int, argument1: Int?) -> Int
}

final class ArgumentMatcherTests: XCTestCase {
	override func setUp() {
		continueAfterFailure = false
		testFailureReport = { message in
			XCTFail(message)
		}
	}
	
	override func tearDown() {
		cleanUpMock()
		super.tearDown()
	}
	
	func testAny() {
		let mock = ArgumentMatcherTestProtocolMock()
		
		let notExpected = 7
		let expectation = 11
		
		when(mock.$call(argument0: any(), argument1: any()))
			.thenReturn(notExpected)
		
		when(mock.$call(argument0: any(), argument1: any()))
			.thenReturn(expectation)
		
		let actualOne = mock.call(argument0: 0, argument1: 0)
		let actualTwo = mock.call(argument0: 1, argument1: 1)
		
		XCTAssertEqual(expectation, actualOne)
		XCTAssertEqual(expectation, actualTwo)
	}
	
	func testEq() {
		let mock = ArgumentMatcherTestProtocolMock()
		
		let expectationOne = 8
		let expectationTwo = 11
		
		when(mock.$call(argument0: eq(7), argument1: any()))
			.thenReturn(expectationTwo)
		
		when(mock.$call(argument0: eq(0), argument1: any()))
			.thenReturn(expectationOne)
		
		let actualOne = mock.call(argument0: 0, argument1: 0)
		let actualTwo = mock.call(argument0: 7, argument1: 1)
		
		XCTAssertEqual(expectationOne, actualOne)
		XCTAssertEqual(expectationTwo, actualTwo)
	}
	
	func testIsNil() {
		let mock = ArgumentMatcherTestProtocolMock()
		
		let expectationOne = 8
		let expectationTwo = 11
		
		when(mock.$call(argument1: isNil()))
			.thenReturn(expectationTwo)
		
		when(mock.$call(argument1: eq(0)))
			.thenReturn(expectationOne)
		
		let actualOne = mock.call(argument0: 0, argument1: 0)
		let actualTwo = mock.call(argument0: 7, argument1: nil)
		
		XCTAssertEqual(expectationOne, actualOne)
		XCTAssertEqual(expectationTwo, actualTwo)
	}
	
	func testIsNotNil() {
		let mock = ArgumentMatcherTestProtocolMock()
		
		let expectationOne = 8
		let expectationTwo = 11
		
		when(mock.$call())
			.thenReturn(expectationOne)
		
		when(mock.$call(argument1: isNotNil()))
			.thenReturn(expectationTwo)
		
		let actualOne = mock.call(argument0: 0, argument1: nil)
		let actualTwo = mock.call(argument0: 7, argument1: 0)
		
		XCTAssertEqual(expectationOne, actualOne)
		XCTAssertEqual(expectationTwo, actualTwo)
	}
	
	func testOr() {
		let mock = ArgumentMatcherTestProtocolMock()
		
		let expectationOne = 8
		let expectationTwo = 11
		
		when(mock.$call(argument0: any()))
			.thenReturn(expectationOne)
		
		when(mock.$call(argument0: eq(7) || lessThan(-5)))
			.thenReturn(expectationTwo)
		
		let actualOne = mock.call(argument0: 0, argument1: nil)
		let actualTwo = mock.call(argument0: 7, argument1: 0)
		
		XCTAssertEqual(expectationOne, actualOne)
		XCTAssertEqual(expectationTwo, actualTwo)
	}
	
	func testMoreThan() {
		let mock = ArgumentMatcherTestProtocolMock()
		
		let expectation = 9
		
		when(mock.$call(argument0: moreThen(5)))
			.thenReturn(expectation)
		
		let actual = mock.call(argument0: 9, argument1: nil)
		
		XCTAssertEqual(expectation, actual)
	}
	
	func testAnd() {
		let mock = ArgumentMatcherTestProtocolMock()
		
		let expectation = 9
		
		when(mock.$call(argument0: moreThen(0) && lessThan(9)))
			.thenReturn(expectation)
		
		let actual = mock.call(argument0: 7, argument1: nil)
		
		XCTAssertEqual(expectation, actual)
	}
}
