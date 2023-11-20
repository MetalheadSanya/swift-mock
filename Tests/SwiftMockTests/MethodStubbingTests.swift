import SwiftMock
import XCTest

enum CustomError: Error {
	case unknown
}

@Mock
protocol EmptyProtocol {
	func call()
}

@Mock
protocol SimpleProtocol {
	func call() -> Int
}

@Mock
protocol TwoArgumentsProtocol {
	func call(argument0: Int, argument1: Int) -> Int
}

@Mock
protocol ThrowsProtocol {
	func call0() throws
	func call() throws -> Int
}

@Mock
protocol AsyncProtocol {
	func call0() async
	func call() async -> Int
}

@Mock
protocol AsyncThrowsProtocol {
	func call0() async throws
	func call() async throws -> Int
}

@Mock
protocol GenericMethodProtocol {
	func oneParameter<T>(parameter: T) -> Int
	func oneParameterAndReturn<T>(parameter: T) -> T
	func inheritedType<T: Equatable>(parameter: T) -> T
}

@Mock
protocol ClosureProtocol {
	func testEscaping(_ f: @escaping (Int) -> Void)
	func testNonEscaping(_ f: (Int) -> Void)
}

@Mock
protocol MethodProtocol {
	func rethrowsMethod(_ f: @escaping () throws -> Void) rethrows
	func asyncRethrowsMethod(_ f: @escaping () throws -> Void) async rethrows
	
	func anyMethod(_ f: any Equatable)
	func someMethod(_ f: some Equatable)
}

final class MethodStubbingTests: XCTestCase {
	override func setUp() {
		continueAfterFailure = false
		testFailureReport = { message in
			XCTFail(message)
		}
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
			.thenAnswer { (argument, _) in argument }
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
	
	func testGenericWithOneParameter() {
		let mock = GenericMethodProtocolMock()
		
		let expectationOne = 6
		
		when(mock.$oneParameter(parameter: any(type: Int.self)))
			.thenReturn(expectationOne)
		
		let actualOne = mock.oneParameter(parameter: 6)
		
		XCTAssertEqual(actualOne, expectationOne)
		
		let expectationTwo = 0
		let parameterTwo = "9"
		
		when(mock.$oneParameter(parameter: eq(parameterTwo)))
			.thenReturn(expectationTwo)
		
		let actualTwo = mock.oneParameter(parameter: parameterTwo)
		
		XCTAssertEqual(actualTwo, expectationTwo)
		
		#if !os(Linux)
		XCTExpectFailure {
			_ = mock.oneParameter(parameter: CustomError.unknown)
		}
		#endif
	}
	
	func testGenericWithOneParameterAndReturn() {
		let mock = GenericMethodProtocolMock()
		
		let expectationOne = 6
		
		when(mock.$oneParameterAndReturn(parameter: any(type: Int.self)))
			.thenReturn(expectationOne)
		
		let actualOne = mock.oneParameterAndReturn(parameter: 6)
		
		XCTAssertEqual(actualOne, expectationOne)
		
		let expectationTwo = "0"
		let parameterTwo = "9"
		
		when(mock.$oneParameterAndReturn(parameter: eq(parameterTwo)))
			.thenReturn(expectationTwo)
		
		let actualTwo = mock.oneParameterAndReturn(parameter: parameterTwo)
		
		XCTAssertEqual(actualTwo, expectationTwo)
		
		#if !os(Linux)
		XCTExpectFailure {
			_ = mock.oneParameterAndReturn(parameter: CustomError.unknown)
		}
		#endif
	}
	
	func testGenericinheritedType() {
		let mock = GenericMethodProtocolMock()
		
		let expectationOne = 6
		
		when(mock.$inheritedType(parameter: any(type: Int.self)))
			.thenReturn(expectationOne)
		
		let actualOne = mock.inheritedType(parameter: 6)
		
		XCTAssertEqual(actualOne, expectationOne)
		
		let expectationTwo = "0"
		let parameterTwo = "9"
		
		when(mock.$inheritedType(parameter: eq(parameterTwo)))
			.thenReturn(expectationTwo)
		
		let actualTwo = mock.inheritedType(parameter: parameterTwo)
		
		XCTAssertEqual(actualTwo, expectationTwo)
		
		#if !os(Linux)
		XCTExpectFailure {
			_ = mock.oneParameterAndReturn(parameter: CustomError.unknown)
		}
		#endif
	}
	
	func testEscapingClosure() throws {
		let mock = ClosureProtocolMock()
		
		when(mock.$testEscaping())
			.thenReturn()
		
		mock.testEscaping { _ in }
		
		verify(mock).testEscaping()
	}
	
	func testNonEscapingClosure() throws {
		let mock = ClosureProtocolMock()
		
		when(mock.$testNonEscaping())
			.thenReturn()
		
		mock.testNonEscaping { _ in }
		
		verify(mock).testNonEscaping()
	}
	
	func testRethrowsMethodReturn() throws {
		let mock = MethodProtocolMock()
		
		when(mock.$rethrowsMethod())
			.thenReturn()
		
		mock.rethrowsMethod { }
		
		verify(mock).rethrowsMethod()
	}
	
	func testRethrowsMethodThrow() throws {
		let mock = MethodProtocolMock()
		
		when(mock.$rethrowsMethod())
			.thenThrow(CustomError.unknown)
		
		XCTAssertThrowsError(
			try mock.rethrowsMethod { throw CustomError.unknown }
		)
		
		verify(mock).rethrowsMethod()
	}
	
	func testAsyncRethrowsMethodReturn() async throws {
		let mock = MethodProtocolMock()
		
		when(mock.$asyncRethrowsMethod())
			.thenReturn()
		
		await mock.asyncRethrowsMethod { }
		
		verify(mock).asyncRethrowsMethod()
	}
	
	func testAsyncRethrowsMethodThrow() async throws {
		let mock = MethodProtocolMock()
		
		when(mock.$asyncRethrowsMethod())
			.thenThrow(CustomError.unknown)
		
		var catchedError: Error?
		do {
			_ = try await mock.asyncRethrowsMethod { throw CustomError.unknown }
		} catch {
			catchedError = error
		}
		XCTAssertNotNil(catchedError)
		
		verify(mock).asyncRethrowsMethod()
	}
	
	func testAnyArgument() {
		let mock = MethodProtocolMock()
		
		when(mock.$anyMethod())
			.thenReturn()
		
		mock.anyMethod(8)
		
		verify(mock).anyMethod()
	}
	
	func testSomeArgument() {
		let mock = MethodProtocolMock()
		
		when(mock.$someMethod())
			.thenReturn()
		
		mock.someMethod(5)
		
		verify(mock).someMethod()
	}
}
