# SwiftMock

A package to simplify writing tests by automating the process of creating mock objects.

## Overview

This package provides a Mock macro that can be applied to a protocol to generate a new type. This type will have a name similar to the protocol name with the Mock suffix.

To work with an object of Mock type, the global `when(_:)` method is used. For each protocol method, 2 methods will be generated. One method will be similar to the protocol method, the second method will have a prefix in the form of the `$` symbol. When you call the `when(_:)` method you should use the method with a prefix.

The `when(_:)` method returns a `MethodInvocationBuilder` that allows you add the stub to Mock object for its methods. In most cases, you should call the builder's `MethodInvocationBuilder.thenReturn(_:)` method and determine what value stub should return. If the method can throw errors, then you can use the `ThrowsMethodInvocationBuilder.thenThrow(_:)` method to test error handling.

### Mock Creation

First of all, I would like to clarify that at the moment the package allows you to create Mock objects only for public protocols that contain only methods and do not contain any properties.

In order to generate a mock type for your protocol, you need to add the `@Mock` macro before the protocol keyword.

```swift
@Mock
public protocol SomeProtocol {
}
```

This macro will generate a new public type with the protocol name and the suffix `Mock`. In our example, the type name will be `SomeProtocolMock`.

### Stubbing basics

Let's add the `getAlbumName()` method to our protocol, which returns the name of the album with the `String` type. And let's move on to writing the test.

```swift
@Mock
public protocol SomeProtocol {
	func getAlbumName() async throws -> String
}
```

From this moment on, the generated mock object contains the basic functionality for stubbing protocol methods. To stub methods we must use the `when(_:)` function. As a function argument, we must indicate which method of which mock object we want to stub. This is done by calling a generated method with an identical name and the `$` prefix on the mock object.

```swift
func testSomeProtocol() async throws {
	let mock = SomeProtocolMock()
	
	when(mock.$getAlbumName())
}
```

The `when(_:)` function returns us a builder, which allows us to determine what our method should return if called. The `AsyncThrowsMethodInvocationBuilder.thenReturn(_:)` method is used for this.

```swift
func testSomeProtocol async throws {
	let mock = SomeProtocolMock()
	
	when(mock.$getAlbumName())
		.thenReturn("I'mperfect")
}
```

After this, whenever we call the `getAlbumName()` method, we will receive the value that we specified in the `thenReturn(_:)` method.

```swift
func testSomeProtocol() async throws {
	let mock = SomeProtocolMock()
	
	when(mock.$getAlbumName())
		.thenReturn("I'mperfect")
	
	let albumName = try await mock.getAlbumName()
	
	XCTAssertEqual("I'mperfect", albumName)
}
```

For more details see: [Stubbing](https://metalheadsanya.github.io/swift-mock/documentation/swiftmock/stubbing)

### Verification basics

When we stab our mock objects, most often we want to check that the necessary methods on the mock object have been called. For this purpose, there is the `verify(_:times:)` method, which allows you to check the number of calls of a particular method and with what arguments it was called.

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

For more details see [Verifying](https://metalheadsanya.github.io/swift-mock/documentation/swiftmock/verifying)


### [Documentation](https://metalheadsanya.github.io/swift-mock/documentation/swiftmock/)
