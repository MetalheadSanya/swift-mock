import SwiftMock
import XCTest

@Mock
public protocol VerifyTestsProtocol {
	func call(argument0: Int, argument1: Int) -> Int
}

final class VerifyTests: XCTestCase {
	override func setUp() {
		continueAfterFailure = false
		testFailureReport = { message in
			XCTFail(message)
		}
	}
	
	func testDefaultsCountDefaultArguments() {
		let mock = VerifyTestsProtocolMock()
		
		when(mock.$call()).thenReturn(9)
		
		_ = mock.call(argument0: 6, argument1: 9)
		
		verify(mock).call()
	}
	
	func testDefaultCountEqArguments() {
		let mock = VerifyTestsProtocolMock()
		
		when(mock.$call()).thenReturn(9)
		
		let argument0 = 6
		let argument1 = 9
		
		_ = mock.call(argument0: argument0, argument1: argument1)
		
		verify(mock).call(argument0: eq(argument0), argument1: eq(argument1))
	}
	
	func testTimes2DefaultArguments() {
		let mock = VerifyTestsProtocolMock()
		
		when(mock.$call()).thenReturn(9)
		
		_ = mock.call(argument0: 6, argument1: 9)
		_ = mock.call(argument0: 4, argument1: 8)
		
		verify(mock, times: times(2)).call()
	}
	
	func testTimesMoreThenArguments() {
		let mock = VerifyTestsProtocolMock()
		
		when(mock.$call()).thenReturn(9)
		
		_ = mock.call(argument0: 6, argument1: 9)
		_ = mock.call(argument0: 4, argument1: 8)
		
		verify(mock, times: times(2)).call(argument0: moreThen(2), argument1: moreThen(2))
	}
	
	func testErrorMessage() {
		let mock = VerifyTestsProtocolMock()
		
		when(mock.$call()).thenReturn(9)
		
		_ = mock.call(argument0: 6, argument1: 9)
		
		#if !os(Linux)
		XCTExpectFailure {
			verify(mock, times: times(2)).call(argument0: moreThen(2), argument1: moreThen(2))
		}
		#endif
	}
	
	func testAtLeast() {
		let mock = VerifyTestsProtocolMock()
		
		when(mock.$call()).thenReturn(9)
		
		let firstTimeCount = 8
		for _ in 0..<firstTimeCount {
			_ = mock.call(argument0: 9, argument1: 5)
		}
		
		verify(mock, times: atLeast(firstTimeCount)).call()
		
		_ = mock.call(argument0: 6, argument1: 0)
		
		verify(mock).call()
	}
	
	func testAtLeastOnce() {
		let mock = VerifyTestsProtocolMock()
		
		when(mock.$call()).thenReturn(9)
		
		#if !os(Linux)
		XCTExpectFailure {
			verify(mock, times: atLeastOnce()).call()
		}
		#endif
		
		_ = mock.call(argument0: 9, argument1: 5)
		_ = mock.call(argument0: 4, argument1: 5)
		
		verify(mock, times: atLeastOnce()).call()
		
		_ = mock.call(argument0: 4, argument1: 9)
		
		verify(mock).call()
	}
	
	func testNever() {
		let mock = VerifyTestsProtocolMock()
		
		when(mock.$call()).thenReturn(9)
		
		verify(mock, times: never()).call()
		
		_ = mock.call(argument0: 8, argument1: 4)
		
		#if !os(Linux)
		XCTExpectFailure {
			verify(mock, times: never()).call()
		}
		#endif
	}
	
	func testAtMost() {
		let mock = VerifyTestsProtocolMock()
		
		when(mock.$call()).thenReturn(9)
		
		verify(mock, times: atMost(2)).call()
		
		for _ in 0..<3 {
			_ = mock.call(argument0: 4, argument1: 7)
		}
		
		#if !os(Linux)
		XCTExpectFailure {
			verify(mock, times: atMost(2)).call()
		}
		#endif
	}
}
