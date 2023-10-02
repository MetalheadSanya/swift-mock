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

