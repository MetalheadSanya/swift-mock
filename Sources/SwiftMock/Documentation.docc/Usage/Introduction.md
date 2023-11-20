# Introduction

First steps in protocol mocking.

## Overview

This article will cover the basic use of the package and the necessary methods to get started.

### Mock Creation

First of all, I would like to clarify that at the moment the package allows you to create Mock objects only for public protocols that contain only methods and do not contain any properties.

In order to generate a mock type for your protocol, you need to add the `@Mock` macro before the protocol keyword.

```swift
@Mock
public protocol SomeProtocol {
}
```

This macro will generate a new public type with the protocol name and the suffix `Mock`. In our example, the type name will be `SomeProtocolMock`.

### Test setup

In test case you should perform some actions for correct working of engine.

First of all you shoud import `SwiftMockConfiguration` module.

You should override `setUp()` and `tearDown()` methods. In `setUp()` method you must set `continueAfterFailure` to false and call `setUp()` function of `SwiftMockConfiguration` module. In `tearDown()` you must call `tearDown()` function of `SwiftMockConfiguration` module.

```swift
final class Tests: XCTestCase {
	override func setUp() {
		continueAfterFailure = false
		SwiftMockConfiguration.setUp()
	}

	override func tearDown() {
		SwiftMockConfiguration.tearDown()
		super.tearDown()
	}

...
```

> Important: `continueAfterFailure` is important for correct running of test. 

### Stubbing basics

Let's add the `getAlbumName()` method to our protocol, which returns the name of the album with the `String` type. And let's move on to writing the test.

```swift
@Mock
public protocol SomeProtocol {
	func getAlbumName() async throws -> String
}
```

From this moment on, the generated mock object contains the basic functionality for stubbing protocol methods. To stub methods we must use the ``when(_:)-1l8q0`` function. As a function argument, we must indicate which method of which mock object we want to stub. This is done by calling a generated method with an identical name and the `$` prefix on the mock object.

```swift
func testSomeProtocol() async throws {
	let mock = SomeProtocolMock()
	
	when(mock.$getAlbumName())
}
```

The ``when(_:)-1l8q0`` function returns us a builder, which allows us to determine what our method should return if called. The ``AsyncThrowsMethodInvocationBuilder/thenReturn(_:)-52q00`` method is used for this.

```swift
func testSomeProtocol async throws {
	let mock = SomeProtocolMock()

	when(mock.$getAlbumName())
		.thenReturn("I'mperfect")
}
```

After this, whenever we call the `getAlbumName()` method, we will receive the value that we specified in the ``AsyncThrowsMethodInvocationBuilder/thenReturn(_:)-52q00`` method.

```swift
func testSomeProtocol() async throws {
	let mock = SomeProtocolMock()

	when(mock.$getAlbumName())
		.thenReturn("I'mperfect")

	let albumName = try await mock.getAlbumName()

	XCTAssertEqual("I'mperfect", albumName)
}
```

For more details see: <doc:Stubbing>

### Verification basics

When we stab our mock objects, most often we want to check that the necessary methods on the mock object have been called. For this purpose, there is the ``verify(_:times:)`` method, which allows you to check the number of calls of a particular method and with what arguments it was called.

Let's look at the following example. We want to write a test that checks that we requested a name for each album id passed in and check that we get the same album names that we passed into the mock in the correct order.

Let's imagine the following facade above our service

```swift
final class SomeFacade {
	var service: SomeProtocol

	init(service: SomeProtocol) {
		self.service = service
	}

	func fetchAlbumNames(_ ids: [String]) async throws -> [String] {
		var albums = [String]
		albums.reserveCapacity(ids.count)
		for id in ids {
			try await albums.append(service.getAlbumName(id: id))
		}
		return albums
	}
}
```

For this test, first of all, we must create a mock and stab the method with all the necessary data. After that, we create our facade object and inject the mock there. As a final step, we call the facade method we want to test, get the data, check it and check the mock calls.

```swift
func testFetchAlbum() async throws {
	let mock = SomeProtocolMock()

	let passedIds = [
		"id1",
		"id2",
		"id3",
		"id4",
	]

	let expected = [
		"#4",
		"Inspiration Is Dead",
		"Just a Moment",
		"Still a Sigure Virgin?",
	]

	for (id, name) in zip(passedIds, expected) {
		when(mock.$getAlbumName(id: eq(id)))
			.thenReturn(name)
	}

	let facade = SomeFacade(service: mock)

	let actual = try await facade.fetchAlbumNames(passedIds)

	XCTAssertEqual(expected, actual)

	for id in passedIds {
		verify(mock).getAlbumName(id: eq(id))
	}
}
```

For more details see <doc:Verifying>
