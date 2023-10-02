# Argument Matchers

This article talks about how Argument Matcher works.

## Overview

``ArgumentMatcher`` is a function that tests an argument for suitability. The ``SwiftMock`` package provides some pre-built ``ArgumentMatcher``s to get you started quickly.

### Any

``any()`` - Argument Matcher which never checks the argument for its value and always returns `true`. If you do not specify any argument matcher for the argument, then the default matcher will be ``any()``.

```swift 
@Mock
public protocol AlbumService {
	func getAlbum(id: UUID) async throws -> Album
}

func test() async throws {
	let expected = Album(
		uuid: UUID(),
		name: "I'mperfect",
		group: "Ling Toshite Shigure"
	)

	let mock = AlbumServiceMock()

	when(mock.$getAlbum(uuid: any()))
		.thenReturn(expected)
}
```

### Equal

``eq(_:)`` is an argument matcher that checks the value of the argument and compares it to the value you pass to the matcher. You can use this matcher with any data type that implements the `Equitable` protocol.

```swift 
@Mock
public protocol AlbumService {
	func getAlbum(id: UUID) async throws -> Album
}

func test() async throws {
	let uuid = UUID() 
	let expected = Album(
		uuid: uuid,
		name: "I'mperfect",
		group: "Ling Toshite Shigure"
	)

	let mock = AlbumServiceMock()

	when(mock.$getAlbum(uuid: eq(uuid)))
		.thenReturn(expected)
}
```

### Nullability

The ``SwiftMock`` package contains two matchers that allow you to check an argument for nullability. ``isNil()`` only passes the test if `nil` is passed as an argument. ``isNotNil()`` only passes if the argument passed is not `nil`.

### Comporation

The ``SwiftMock`` package contains two matchers that allow you to check an argument using comparison operations. ``moreThen(_:)`` checks that the passed argument is strictly greater than the value passed to the matcher. ``lessThan(_:)`` checks that the passed argument is strictly less than the value passed to the matcher. You can only use these matchers for arguments of types that implement the `Comparable` protocol.

### Matcher Composition

You can use the `&&` and `||` operators to combine several matchers into one. As you can guess from the operators, `&&` creates a new matcher that checks the argument against two other matchers and if the argument matches *both*, then the argument passes the test of the new created matcher. `||` creates a new matcher that passes the test if the argument passes *any* of the two passed matchers.

As with conditions, for the `&&` operator, if the first matcher was **not passed**, then the second matcher **will not** be checked. In the case of the operator `||` if the first matcher was **passed**, then the second matcher **will not** be checked.

### Creating Argument Matcher

To create your own ``ArgumentMatcher``, you need to declare a function with the name of the matcher. This function must return a new function with the type of the receiving argument and returning `Bool` (eg. `(Album) -> Bool`).

The return function must take an argument, check whether it passes the test, and return `true` if the test passes or `false` if the test fails. Let's look at some predefined ``ArgumentMatcher``:

```swift
// Take any argument of any type and always test pass
func any<Arguments>() -> ArgumentMatcher<Arguments> {
	{ _ in
		true
	}
}
```

```swift
/// Take any argument of any Equitable type and return true if
/// argument is equal to passed parameter to matcher.
public func eq<Arguments>(
	_ value: Arguments
) -> ArgumentMatcher<Arguments> where Arguments: Equatable {
	{ argument in
		argument == value
	}
}
```

```swift
/// Take two argument mathers and creates new one. New mather pass
/// if argument pass both mathers.
public func &&<T>(
	_ matcher0: @escaping ArgumentMatcher<T>, 
	_ matcher1: @escaping ArgumentMatcher<T>
) -> ArgumentMatcher<T> {
	{ argument in
		matcher0(argument) && matcher1(argument)
	}
}
```

