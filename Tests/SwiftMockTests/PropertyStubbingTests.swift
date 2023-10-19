import SwiftMock
import XCTest

@Mock
protocol GetPropertyProtocol {
	var property: Int { get }
}

@Mock
protocol GetSetPropertyProtocol {
	var property: Int { get set }
}

@Mock
protocol ThrowsGetPropertyProtocol {
	var property: Int { get throws }
}

final class PropertyStubbingTests: XCTestCase {
	override func setUp() {
		continueAfterFailure = false
		testFailureReport = { message in
			XCTFail(message)
		}
	}
	
	func testGetProperty() {
		let mock = GetPropertyProtocolMock()

		let expected = 6
		
		when(mock.$propertyGetter())
			.thenReturn(expected)
		
		let actual = mock.property
		
		XCTAssertEqual(expected, actual)
	}
	
	func testGetPropertyTwice() {
		let mock = GetPropertyProtocolMock()
		
		let expected1 = 6
		let expected2 = 9
		
		when(mock.$propertyGetter())
			.thenReturn(expected1)
			.thenReturn(expected2)
		
		let actual1 = mock.property
		let actual2 = mock.property
		let actual3 = mock.property
		
		XCTAssertEqual(expected1, actual1)
		XCTAssertEqual(expected2, actual2)
		XCTAssertEqual(expected2, actual3)
	}
	
	func testGetSetProperty() {
		let mock = GetSetPropertyProtocolMock()
		
		let expected = 4
		
		when(mock.$propertyGetter())
			.thenReturn(expected)
		
		when(mock.$propertySetter(eq(9)))
			.thenReturn()
		
		let actual = mock.property
		
		XCTAssertEqual(expected, actual)
		
		#if !os(Linux)
		XCTExpectFailure {
			mock.property = 7
		}
		#endif
	}
	
	func testThrowsGetPropertyReturn() throws {
		let mock = ThrowsGetPropertyProtocolMock()
		
		let expected = 4
		
		when(mock.$propertyGetter())
			.thenReturn(expected)
		
		let actual = try mock.property
		
		XCTAssertEqual(expected, actual)
	}
	
	func testThrowsGetPropertyThrow() throws {
		let mock = ThrowsGetPropertyProtocolMock()
		
		let expected = CustomError.unknown
		
		when(mock.$propertyGetter())
			.thenThrow(expected)
		
		XCTAssertThrowsError(try mock.property)
	}
}
