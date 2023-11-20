import SwiftMock
import SwiftMockConfiguration
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

@Mock
protocol AsyncGetPropertyProtocol {
	var property: Int { get async }
}

@Mock
protocol AsyncThrowsGetPropertyProtocol {
	var property: Int { get async throws }
}

final class PropertyStubbingTests: XCTestCase {
	override func setUp() {
		continueAfterFailure = false
		SwiftMockConfiguration.setUp()
	}
	
	override func tearDown() {
		SwiftMockConfiguration.tearDown()
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
	
	func testAsyncGetProperty() async {
		let mock = AsyncGetPropertyProtocolMock()
		
		let expected = 4
		
		when(mock.$propertyGetter())
			.thenReturn(expected)
		
		let actual = await mock.property
		
		XCTAssertEqual(expected, actual)
	}
	
	func testAsyncThrowsGetPropertyReturn() async throws {
		let mock = AsyncThrowsGetPropertyProtocolMock()
		
		let expected = 4
		
		when(mock.$propertyGetter())
			.thenReturn(expected)
		
		let actual = try await mock.property
		
		XCTAssertEqual(expected, actual)
	}
	
	func testAsyncThrowsGetPropertyThrow() async throws {
		let mock = AsyncThrowsGetPropertyProtocolMock()
		
		let expected = CustomError.unknown
		
		when(mock.$propertyGetter())
			.thenThrow(expected)
		
		var catchedError: Error?
		do {
			_ = try await mock.property
		} catch {
			catchedError = error
		}
		XCTAssertNotNil(catchedError)
	}
}
