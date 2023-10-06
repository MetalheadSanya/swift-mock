import SwiftMock
import XCTest

@Mock
public protocol VerifyTestsProtocol {
	func call(argument0: Int, argument1: Int) -> Int
}

final class VerifyTests: XCTestCase {
	var testFailMessage: String?
	
	
	override func setUp() {
		continueAfterFailure = false
		testFailureReport = { message in
			self.testFailMessage = message
		}
	}
	
	func testDefaultsCountDefaultArguments() {
		let mock = VerifyTestsProtocolMock()
		
		when(mock.$call()).thenReturn(9)
		
		_ = mock.call(argument0: 6, argument1: 9)
		
		verify(mock).call()
		
		XCTAssertNil(testFailMessage)
	}
	
	func testDefaultCountEqArguments() {
		let mock = VerifyTestsProtocolMock()
		
		when(mock.$call()).thenReturn(9)
		
		let argument0 = 6
		let argument1 = 9
		
		_ = mock.call(argument0: argument0, argument1: argument1)
		
		verify(mock).call(argument0: eq(argument0), argument1: eq(argument1))
		
		XCTAssertNil(testFailMessage)
	}
	
	func testTimes2DefaultArguments() {
		let mock = VerifyTestsProtocolMock()
		
		when(mock.$call()).thenReturn(9)
		
		_ = mock.call(argument0: 6, argument1: 9)
		_ = mock.call(argument0: 4, argument1: 8)
		
		verify(mock, times: times(2)).call()
		
		XCTAssertNil(testFailMessage)
	}
	
	func testTimesMoreThenArguments() {
		let mock = VerifyTestsProtocolMock()
		
		when(mock.$call()).thenReturn(9)
		
		_ = mock.call(argument0: 6, argument1: 9)
		_ = mock.call(argument0: 4, argument1: 8)
		
		verify(mock, times: times(2)).call(argument0: moreThen(2), argument1: moreThen(2))
		
		XCTAssertNil(testFailMessage)
	}
	
	func testErrorMessage() {
		let mock = VerifyTestsProtocolMock()
		
		when(mock.$call()).thenReturn(9)
		
		_ = mock.call(argument0: 6, argument1: 9)
		
		verify(mock, times: times(2)).call(argument0: moreThen(2), argument1: moreThen(2))
		
		XCTAssertEqual("VerifyTestsProtocolMock.call(argument0:argument1:): incorrect calls count: 1", testFailMessage)
	}
	
	func testAtLeast() {
		let mock = VerifyTestsProtocolMock()
		
		when(mock.$call()).thenReturn(9)
		
		let firstTimeCount = 8
		for _ in 0..<firstTimeCount {
			_ = mock.call(argument0: 9, argument1: 5)
		}
		
		verify(mock, times: atLeast(firstTimeCount)).call()
		XCTAssertNil(testFailMessage)
		
		_ = mock.call(argument0: 6, argument1: 0)
		
		verify(mock, times: atLeast(firstTimeCount)).call()
		XCTAssertNil(testFailMessage)
	}
	
	func testAtLeastOnce() {
		let mock = VerifyTestsProtocolMock()
		
		when(mock.$call()).thenReturn(9)
		
		verify(mock, times: atLeastOnce()).call()
		XCTAssertEqual("VerifyTestsProtocolMock.call(argument0:argument1:): incorrect calls count: 0", testFailMessage)
		testFailMessage = nil
		
		_ = mock.call(argument0: 9, argument1: 5)
		
		verify(mock, times: atLeastOnce()).call()
		XCTAssertNil(testFailMessage)
		
		_ = mock.call(argument0: 4, argument1: 9)
		
		verify(mock, times: atLeastOnce()).call()
		XCTAssertNil(testFailMessage)
	}
	
	func testNever() {
		let mock = VerifyTestsProtocolMock()
		
		when(mock.$call()).thenReturn(9)
		
		verify(mock, times: never()).call()
		XCTAssertNil(testFailMessage)
		
		_ = mock.call(argument0: 8, argument1: 4)
		
		verify(mock, times: never()).call()
		XCTAssertEqual("VerifyTestsProtocolMock.call(argument0:argument1:): incorrect calls count: 1", testFailMessage)
	}
	
	func testAtMost() {
		let mock = VerifyTestsProtocolMock()
		
		when(mock.$call()).thenReturn(9)
		
		verify(mock, times: atMost(2)).call()
		XCTAssertNil(testFailMessage)
		
		for _ in 0..<3 {
			_ = mock.call(argument0: 4, argument1: 7)
		}
		
		verify(mock, times: atMost(2)).call()
		XCTAssertEqual("VerifyTestsProtocolMock.call(argument0:argument1:): incorrect calls count: 3", testFailMessage)
	}
}
