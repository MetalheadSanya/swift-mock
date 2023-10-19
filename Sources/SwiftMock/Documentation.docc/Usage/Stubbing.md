# Stubbing

This article describes in detail the available possibilities of the stubbing method.

## Overview

When we work with mocks we want to have some flexibility in our capabilities. Let's look at the package's capabilities.

### Property Stubbing

Sometimes our services have not only methods, but also properties. For each property declared in the protocol, methods are generated for property stubbing. If a property is declared as read-only, then one stubbing method is generated in the form `$propertyNameGetter`, where `propertyName` is the name of the property. Stubbing using this method is similar to stubbing methods.

```swift 
@Mock
public protocol SomeService {
	var property: Int { get }
}

func test() {
	let mock = SomeServiceMock()

	when(mock.$propertyGetter())
		.thenReturn(15)
	
	XCTAssertEqual(15, mock.property)
}
```

If a property is declared mutable, then in addition to getter stubbing, an additional method is generated for setter stubbing. This method is named `$propertyNameSetter` and has a signature similar to a stubbing method with one argument and no return value. If your code is going to change this property, you MUST stub the property's setter.

```swift 
@Mock
public protocol SomeService {
	var property: Int { get set }
}

func test() {
	let mock = SomeServiceMock()

	when(mock.$propertySetter())
		.thenReturn()

	mock.property = 15
}
```

Similar to method stubbing, you can define different stubbing for assignment different values

```swift 
@Mock
public protocol SomeService {
	var property: Int { get set }
}

func test() {
	let mock = SomeServiceMock()

	when(mock.$propertySetter())
		.thenReturn { _ in print("Some value was set") }
	when(mock.$propertySetter(eq(15)))
		.thenReturn { _ in print("Value 15 was set") }

	// Prints: Value 15 was set
	mock.property = 15
}
```

### Calling Methods Sequentially

In some flows, the methods of our mocks may be called several times and we do not always want to receive the same return value. To do this, we can use the builder's call chain.

```swift 
@Mock
public protocol AlbumService {
	func getAlbumName() async throws -> String
}

func test() {
	let mock = AlbumServiceMock()
	
	when(mock.$getAlbumName())
		.thenReturn("#4")
		.thenReturn("Inspiration Is Dead")
		.thenReturn("Just a Moment")
}
```

In this case, the first time we call the `getAlbumName()` method, we will get the value `"#4"`, the second time we will get the value `"Inspiration Is Dead"`, and all subsequent times we will get the value `"Just a Moment"`.

### Dealing with errors

Sometimes we want to test not only the success path of our code, but also those moments when one of our services threw us some error at a certain moment. The ``ThrowsMethodInvocationBuilder/thenThrow(_:)`` method is used for this. Please note that this method is present in the builder only if the method we want to stub is marked as `throws`.

```swift 
@Mock
public protocol AlbumService {
	func getAlbumName() async throws -> String
}

public enum AlbumServiceError: Error {
	case endOfDiscography
}

func test() {
	let mock = AlbumServiceMock()

	when(mock.$getAlbumName())
		.thenReturn("#4")
		.thenReturn("Inspiration Is Dead")
		.thenThrow(AlbumServiceError.endOfDiscography)
		.thenReturn("#4")
}
```

In this case, after retrieving the first two albums of the group when calling the `getAlbumName()` method, the method will throw an `endOfDiscography` error.

In addition to this, we can see that we can combine ``ThrowsMethodInvocationBuilder/thenReturn(_:)-23hjy`` and ``ThrowsMethodInvocationBuilder/thenThrow(_:)`` in any order we need.

``ThrowsMethodInvocationBuilder/thenThrow(_:)`` can be used not only for throws methods but throws properties.

```swift 
@Mock
public protocol AlbumService {
	var current: String { get throws }
}

public enum AlbumServiceError: Error {
	case endOfDiscography
}

func test() {
	let mock = AlbumServiceMock()

	when(mock.$currentGetter())
		.thenReturn("#4")
		.thenReturn("Inspiration Is Dead")
		.thenThrow(AlbumServiceError.endOfDiscography)
		.thenReturn("#4")
}
```

In this case, after retrieving the first two albums of the group when reading the `current` property, the property will throw an `endOfDiscography` error.

### Argument Matchers

By default, a method stubbing accepts any arguments and does not check them in any way. To describe method stubbing for specific arguments, we can use the ``eq(_:)`` function.


```swift 
@Mock
public protocol AlbumService {
	func getAlbum(id: UUID, group: String) async throws -> Album
}

public enum AlbumServiceError: Error {
	case notFound
}

func test() async throws {
	let uuid = UUID()
	let expected = Album(
		uuid: uuid,
		name: "Last Aurorally",
		group: "Ling Toshite Shigure"
	)

	let mock = AlbumServiceMock()

	when(mock.$getAlbum(id: eq(uuid)))
		.thenReturn(album)

	let actual = try await mock.getAlbum(
		id: uuid, 
		group: "Ling Toshite Shigure"
	)
}
```

You can omit any arguments you don't want to check. In this case, matcher ``any()`` will be used for this argument.

### Stubbing order

The order of stubbing plays an important role in choosing what data the system will use. The system looks for the last matching registered stubbing in order to return a value. In this regard, it is recommended to always first describe more general stubbings, using ``any()`` for example, and then more specific ones.

```swift 
@Mock
public protocol AlbumService {
	func getAlbum(id: UUID) async throws -> Album
}

public enum AlbumServiceError: Error {
	case notFound
}

func test() async throws {
	let uuid = UUID()
	let expected = Album(
		uuid: uuid,
		name: "Last Aurorally",
		group: "Ling Toshite Shigure"
	)

	let mock = AlbumServiceMock()

	when(mock.$getAlbum())
		.thenThrow(AlbumServiceError.notFound)
	when(mock.$getAlbum(id: eq(uuid)))
		.thenReturn(album)

	let actual = try await mock.getAlbum(
		id: uuid
	)
}
```

If we swap the stubbing of the `getAlbum()` method in this example, we will always get an error, since our specific `uuid` matches the ``any()`` matcher check.

### Override Stubbing

If we sequentially define two stubbings with the same argument matchers, then the second stubbing will override the first. This means that we will never get the same values or errors that we described in the first one.

If you really need such functionality, then your code most likely has a smell, but such a possibility still exists.

```swift 
@Mock
public protocol AlbumService {
	func getAlbum(id: UUID) async throws -> Album
}

public enum AlbumServiceError: Error {
	case notFound
}

func test() async throws {
	let uuid = UUID()
	let expected = Album(
		uuid: uuid,
		name: "I'mperfect",
		group: "Ling Toshite Shigure"
	)

	let mock = AlbumServiceMock()

	when(mock.$getAlbum())
		.thenThrow(AlbumServiceError.notFound)

	let album = try await mock.getAlbum(uuid: UUID()) // Throw a error.

	when(mock.$getAlbum())
		.thenReturn(expected)

	// All calls of getAlbum() will return "I'mperfect" album.
}
```
