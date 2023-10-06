# Verifying

This article describes in detail the available possibilities of the ``verify(_:times:)`` method.

## Overview

When we work with mocks we want to have some flexibility in our capabilities. Let's look at the package's capabilities.

### Checking that method was called

To verify that the mock method was called, use the ``verify(_:times:)`` method and pass the mock object as the first argument. This method will create a `Verify` structure for you that has the same methods as your protocol. You can call any method from the protocol methods to check that the method has currently been called.

```swift 
@Mock
public protocol AlbumService {
	func getAlbumName(id: String) async throws -> String
}


func test() {
	let mock = AlbumServiceMock()

	when(mock.$getAlbumName())
		.thenReturn("#4")

	_ = mock.getAlbumName(id: "id1")

	verify(mock).getAlbumName()
}
```

By default, verify checks that the method was called exactly one time. If the method was called more than once, you will receive an error.

### Checking that method was called with specific arguments

The methods of a `Verify` structure have all the same methods as your protocol with one exception. All method arguments are replaced with a wrapper in the form of ``ArgumentMatcher``. As with stubbing, the default argument value is ``any()``. If you want to check that a method was called with a certain argument, then you need to specify the appropriate ``ArgumentMatcher`` for the arguments you want to check.

```swift 
@Mock
public protocol AlbumService {
	func getAlbumName(id: String) async throws -> String
}


func test() {
	let mock = AlbumServiceMock()

	when(mock.$getAlbumName())
		.thenReturn("#4")

	_ = mock.getAlbumName(id: "id1")

	// This test fail, because we don't have 
	// mock.getAlbumName(id: "id2") in out test. 
	verify(mock).getAlbumName(id: eq("id2")) 
}
```
### Checking that method was called specific times

The ``verify(_:times:)`` method can check not only that the method was called once, but also a specific number of times. The `times` parameter of the ``verify(_:times:)`` method is used for this. This parameter type is ``TimesMatcher`` and you can use ``times(_:)``, ``never()``, ``atLeast(_:)``, ``atMost(_:)`` as examples, or create your own.

The following example checks that the method has been called at least twice.

```swift 
@Mock
public protocol AlbumService {
	func getAlbumName(id: String) async throws -> String
}


func test() {
	let mock = AlbumServiceMock()

	when(mock.$getAlbumName())
		.thenReturn("#4")
		.thenReturn("Inspiration Is Dead")

	_ = mock.getAlbumName(id: "id1")
	_ = mock.getAlbumName(id: "id2")

	verify(mock, times: atLeast(2)).getAlbumName() 
}
```
