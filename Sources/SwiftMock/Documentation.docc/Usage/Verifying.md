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

> Important: The framework only checks calls that have not yet been checked. If you repeat the method check a second time, you will receive an error that the call was not found.

### Checking that property was read

To verify that the mock property has been read, use the ``verify(_:times:)`` method and pass the mock object as the first argument. This method will create a `Verify` structure for you that has a method to verify that your property has been read. The name of the method is `propertyGetter()`, where `property` is the name of your property. All rules regarding method call verification work similarly for properties.

```swift 
@Mock
public protocol SomeService {
	var property: Int { get }
}


func test() {
	let mock = SomeServiceMock()

	when(mock.$propertyGetter())
		.thenReturn(4)

	_ = mock.property

	verify(mock).propertyGetter()
}
```

By default, verify checks that the property was read exactly one time. If the property was read more than once, you will receive an error.

### Checking that property was write

To verify that the mock property has been write, use the ``verify(_:times:)`` method and pass the mock object as the first argument. This method will create a `Verify` structure for you that has a method to verify that your property has been write. The name of the method is `propertySetter(_:)`, where `property` is the name of your property. All rules regarding method call verification work similarly for properties. Additionally, you can pass any `AttributeMatcher` to the `propertySetter(_:)` method to check that a certain value has been set to the property.

```swift 
@Mock
public protocol SomeService {
	var property: Int { get set }
}


func test() {
	let mock = SomeServiceMock()

	when(mock.$propertySetter())
		.thenReturn()

	mock.property = 6

	// Checking that any value has been set to the property.
	verify(mock).propertySetter()

	// Checking that 6 (six) has been set to the property.
	verify(mock).propertySetter(eq(6))
}
```

### Checking that subscript was read

To verify that the mock subscript has been read, use the ``verify(_:times:)`` method and pass the mock object as the first argument. This method will create a `Verify` structure for you that has a method to verify that your subscript has been read. The name of the method is `subscriptGetter()`. All rules regarding method call verification work similarly for subscript.

```swift
@Mock
protocol SubscriptProtocol {
	subscript(_ value: Int) -> String  { get set }
}

func test() {
	let mock = SubscriptProtocolMock()

	when(mock.$subscriptGetter(eq(6)))
		.thenReturn("4")

	_ = mock[6]

	verify(mock).subscriptGetter()
}
```

### Checking that subscript was write

To verify that the mock subscript has been write, use the ``verify(_:times:)`` method and pass the mock object as the first argument. This method will create a `Verify` structure for you that has a method to verify that your property has been write. The name of the method is `subscriptSetter`. All rules regarding method call verification work similarly for subscripts. Additionally, you can pass any `AttributeMatcher` to the `subscriptSetter` method as `newValue` arfument to check that a certain value has been set to the subscript.

```swift 
@Mock
protocol SubscriptProtocol {
	subscript(_ value: Int) -> String  { get set }
}


func test() {
	let mock = SubscriptProtocolMock()

	when(mock.$subscriptSetter())
		.thenReturn()

	mock[6] = "7"

	verify(mock).subscriptGetter(eq(6), newValue: eq("7"))
}
```

### Checking that method was called with specific arguments

The methods of a `Verify` structure have all the same methods as your protocol with one exception. All method arguments are replaced with a wrapper in the form of `ArgumentMatcher`. As with stubbing, the default argument value is ``any()``. If you want to check that a method was called with a certain argument, then you need to specify the appropriate `ArgumentMatcher` for the arguments you want to check.

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

The ``verify(_:times:)`` function can check not only that the method was called once, but also a specific number of times. The `times` parameter of the ``verify(_:times:)`` method is used for this. This parameter type is ``TimesMatcher`` and you can use ``times(_:)``, ``never()``, ``atLeast(_:)``, ``atMost(_:)`` as examples, or create your own.

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

> Important: Using ``atLeast(_:)`` and ``atMost(_:)`` will mark all calls that match the passed ``ArgumentMatcher``s as verified.

### Verification in order

The ``inOrder(_:)`` function allows you to check that mock methods were called in a certain order. To do this, you need to call the ``inOrder(_:)`` function and pass there the mocks for interaction with which you want to check. The function returns the ``InOrder`` class which has a ``InOrder/verify(_:times:)`` method that works similar to the function of the same name.

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

	let inOrder = inOrder(mock)

	_ = mock.getAlbumName(id: "id1")
	_ = mock.getAlbumName(id: "id2")
	
	// Check that method was called with id: "id1"
	inOrder.verify(mock).getAlbumName(id: eq("id1")) 
	// Check that method was called with id: "id2"
	// after than with id: "id1"
	inOrder.verify(mock).getAlbumName(id: eq("id2"))
}
```

> Tips: Verification in order is flexible - you don't have to verify all interactions one-by-one but only those that you are interested in testing in order.

> Important: ``InOrder`` verification is 'greedy', but you will hardly ever notice it. If you want to find out more, read: <doc:Greedy-Algorithm>.
