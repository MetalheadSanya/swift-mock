import SwiftMock
import XCTest

enum CustomError: Error {
	case unknown
}

@Mock
public protocol EmptyProtocol {
	func call()
}

@Mock
public protocol SimpleProtocol {
	func call() -> Int
}

@Mock
public protocol TwoArgumentsProtocol {
	func call(argument0: Int, argument1: Int) -> Int
}

@Mock
public protocol ThrowsProtocol {
	func call0() throws
	func call() throws -> Int
}

@Mock
public protocol AsyncProtocol {
	func call0() async
	func call() async -> Int
}

@Mock
public protocol AsyncThrowsProtocol {
	func call0() async throws
	func call() async throws -> Int
}

final class SwiftMockTests: XCTestCase {
	override func setUp() {
		continueAfterFailure = false
	}
	
	func testEmptyProtocol() throws {
		let mock = EmptyProtocolMock()
		when(mock.$call()).thenReturn()
		mock.call()
	}
	
	func testMockSimpleProtocol() throws {
		let mock = SimpleProtocolMock()
		let expectation = -1
		when(mock.$call()).thenReturn(expectation)
		let actual = mock.call()
		XCTAssertEqual(expectation, actual)
	}
	
	func testMockTwoArguments() throws {
		let mock = TwoArgumentsProtocolMock()
		let expectationOne = 8
		let expectationTwo = 11
		when(mock.$call())
			.thenReturn(expectationOne)
			.thenReturn(expectationTwo)
		let actualOne = mock.call(argument0: .random(in: 0..<15), argument1: .random(in: 0..<15))
		let actualTwo = mock.call(argument0: .random(in: 0..<15), argument1: .random(in: 0..<15))
		XCTAssertEqual(expectationOne, actualOne)
		XCTAssertEqual(expectationTwo, actualTwo)
	}
	
	func testMockTwoArgumentsCustomAnswer() throws {
		let mock = TwoArgumentsProtocolMock()
		let expectationOne = 8
		let expectationTwo = 11
		when(mock.$call())
			.thenReturn { (argument, _) in argument }
			.thenReturn(expectationTwo)
		let actualOne = mock.call(argument0: expectationOne, argument1: 0)
		let actualTwo = mock.call(argument0: 0, argument1: 0)
		XCTAssertEqual(expectationOne, actualOne)
		XCTAssertEqual(expectationTwo, actualTwo)
	}
	
	func testMockThrows() throws {
		let mock = ThrowsProtocolMock()
		when(mock.$call())
			.thenReturn(8)
			.thenThrow(CustomError.unknown)
		
		when(mock.$call0())
			.thenReturn()
		
		XCTAssertNoThrow(try mock.call())
		XCTAssertThrowsError(try mock.call())
		
		XCTAssertNoThrow(try mock.call0())
	}
	
	func testAsyncMock() async throws {
		let mock = AsyncProtocolMock()
		let expectationOne = 6
		let expectationTwo = 9
		
		when(mock.$call())
			.thenReturn(expectationOne)
			.thenReturn(expectationTwo)
		
		when(mock.$call0())
			.thenReturn()
		
		let actualOne = await mock.call()
		let actualTwo = await mock.call()
		await mock.call0()
		
		XCTAssertEqual(expectationOne, actualOne)
		XCTAssertEqual(expectationTwo, actualTwo)
	}
	
	func testAsyncThrowsMock() async throws {
		let mock = AsyncThrowsProtocolMock()
		let expectation = 6

		when(mock.$call())
			.thenReturn(expectation)
			.thenThrow(CustomError.unknown)
		
		when(mock.$call0())
			.thenReturn()

		let actual = try await mock.call()
		XCTAssertEqual(expectation, actual)

		var catchedError: Error?
		do {
			_ = try await mock.call()
		} catch {
			catchedError = error
		}
		XCTAssertNotNil(catchedError)
		
		do {
			catchedError = nil
			try await mock.call0()
		} catch {
			catchedError = error
		}
		XCTAssertNil(catchedError)
	}
}
