import Foundation

/// Enables stubbing methods. Use it when you want the mock to return particular value when particular method is called.
///
/// Simply put: "*when* the x method is called *then* return y".
///
/// Examples:
///
/// ```swift
/// when(mock.$someMethod()).thenReturn(10)
/// ```
///
/// You can use flexible argument matchers, e.g:
/// ```swift
/// when(mock.$someMethod(argument: any())).thenReturn(10)
///	```
///
/// Setting exception to be thrown:
/// ```swift
/// when(mock.$someMethod(argument: eq("some arg"))).thenThrow(SomeError.error)
/// ```
///
/// You can set different behavior for consecutive method calls.
/// Last stubbing (e.g: thenReturn("foo")) determines the behavior of further consecutive calls.
/// ```swift
/// when(mock.$someMethod(argument: eq("some arg")))
/// 	.thenThrow(SomeError.error)
/// 	.thenReturn("foo")
/// ```
///
/// - Note: Stubbing can be overridden: for example common stubbing can go to fixture
/// 	setup but the test methods can override it.
/// 	Please note that overriding stubbing is a potential code smell that points out too much stubbing.
/// - Note: Once stubbed, the method will always return stubbed value regardless
/// 	of how many times it is called.
/// - Note: Last stubbing is more important - when you stubbed the same method with
/// 	the same arguments many times.
public func when<Arguments, Result>(
	_ method: MethodSignature<Arguments, Result>
) -> MethodInvocationBuilder<Arguments, Result> {
	MethodInvocationBuilder(
		argumentMatcher: method.argumentMatcher,
		register: method.register
	)
}

/// Enables stubbing methods. Use it when you want the mock to return particular value when particular method is called.
///
/// Simply put: "*when* the x method is called *then* return y".
///
/// Examples:
///
/// ```swift
/// when(mock.$someMethod()).thenReturn(10)
/// ```
///
/// You can use flexible argument matchers, e.g:
/// ```swift
/// when(mock.$someMethod(argument: any())).thenReturn(10)
///	```
///
/// Setting exception to be thrown:
/// ```swift
/// when(mock.$someMethod(argument: eq("some arg"))).thenThrow(SomeError.error)
/// ```
///
/// You can set different behavior for consecutive method calls.
/// Last stubbing (e.g: thenReturn("foo")) determines the behavior of further consecutive calls.
/// ```swift
/// when(mock.$someMethod(argument: eq("some arg")))
/// 	.thenThrow(SomeError.error)
/// 	.thenReturn("foo")
/// ```
///
/// - Note: Stubbing can be overridden: for example common stubbing can go to fixture
/// 	setup but the test methods can override it.
/// 	Please note that overriding stubbing is a potential code smell that points out too much stubbing.
/// - Note: Once stubbed, the method will always return stubbed value regardless
/// 	of how many times it is called.
/// - Note: Last stubbing is more important - when you stubbed the same method with
/// 	the same arguments many times.
public func when<Arguments, Result>(
	_ method: ThrowsMethodSignature<Arguments, Result>
) -> ThrowsMethodInvocationBuilder<Arguments, Result> {
	ThrowsMethodInvocationBuilder(
		argumentMatcher: method.argumentMatcher,
		register: method.register
	)
}

/// Enables stubbing methods. Use it when you want the mock to return particular value when particular method is called.
///
/// Simply put: "*when* the x method is called *then* return y".
///
/// Examples:
///
/// ```swift
/// when(mock.$someMethod()).thenReturn(10)
/// ```
///
/// You can use flexible argument matchers, e.g:
/// ```swift
/// when(mock.$someMethod(argument: any())).thenReturn(10)
///	```
///
/// Setting exception to be thrown:
/// ```swift
/// when(mock.$someMethod(argument: eq("some arg"))).thenThrow(SomeError.error)
/// ```
///
/// You can set different behavior for consecutive method calls.
/// Last stubbing (e.g: thenReturn("foo")) determines the behavior of further consecutive calls.
/// ```swift
/// when(mock.$someMethod(argument: eq("some arg")))
/// 	.thenThrow(SomeError.error)
/// 	.thenReturn("foo")
/// ```
///
/// - Note: Stubbing can be overridden: for example common stubbing can go to fixture
/// 	setup but the test methods can override it.
/// 	Please note that overriding stubbing is a potential code smell that points out too much stubbing.
/// - Note: Once stubbed, the method will always return stubbed value regardless
/// 	of how many times it is called.
/// - Note: Last stubbing is more important - when you stubbed the same method with
/// 	the same arguments many times.
public func when<Arguments, Result>(
	_ method: AsyncMethodSignature<Arguments, Result>
) -> AsyncMethodInvocationBuilder<Arguments, Result> {
	AsyncMethodInvocationBuilder(
		argumentMatcher: method.argumentMatcher,
		register: method.register
	)
}

/// Enables stubbing methods. Use it when you want the mock to return particular value when particular method is called.
///
/// Simply put: "*when* the x method is called *then* return y".
///
/// Examples:
///
/// ```swift
/// when(mock.$someMethod()).thenReturn(10)
/// ```
///
/// You can use flexible argument matchers, e.g:
/// ```swift
/// when(mock.$someMethod(argument: any())).thenReturn(10)
///	```
///
/// Setting exception to be thrown:
/// ```swift
/// when(mock.$someMethod(argument: eq("some arg"))).thenThrow(SomeError.error)
/// ```
///
/// You can set different behavior for consecutive method calls.
/// Last stubbing (e.g: thenReturn("foo")) determines the behavior of further consecutive calls.
/// ```swift
/// when(mock.$someMethod(argument: eq("some arg")))
/// 	.thenThrow(SomeError.error)
/// 	.thenReturn("foo")
/// ```
///
/// - Note: Stubbing can be overridden: for example common stubbing can go to fixture
/// 	setup but the test methods can override it.
/// 	Please note that overriding stubbing is a potential code smell that points out too much stubbing.
/// - Note: Once stubbed, the method will always return stubbed value regardless
/// 	of how many times it is called.
/// - Note: Last stubbing is more important - when you stubbed the same method with
/// 	the same arguments many times.
public func when<Arguments, Result>(
	_ method: AsyncThrowsMethodSignature<Arguments, Result>
) -> AsyncThrowsMethodInvocationBuilder<Arguments, Result> {
	AsyncThrowsMethodInvocationBuilder(
		argumentMatcher: method.argumentMatcher,
		register: method.register
	)
}

/// Creates a `Verify` structure specific to a mock object whose method calls need to be verified.
///
/// - Parameters:
/// 	- mock: Mock object  whose method calls need to be verified.
/// 	- times: How many calls do we want to check.
/// - Returns: New `Verify` structure specific to a mock object.
///
/// Verifies certain behavior happened at least once/exact number of times/never. E.g:
/// ```swift
///	verify(mock, times: times(5)).someMethod(argument: eq("was called five times"))
///
///	verify(mock, times: atLeast(2)).someMethod(argument: eq("was called at least two times"))
///
///	verify(mock, times: atLeastOnce()).someMethod()
/// ```
///
/// **`times(1)` is the default** and can be omitted.
///
/// Arguments passed are compared using ``ArgumentMatcher``.
/// Read about ``ArgumentMatcher`` to find out other ways of matching / asserting arguments passed.
/// <p>
public func verify<Mock: Verifiable>(_ mock: Mock, times: @escaping TimesMatcher = times(1)) -> Mock.Verify {
	Mock.Verify(mock: mock, container: mock.container, times: times)
}

/// Creates new ``InOrder`` struct with 0 (zero) offset of call stack.
///
/// - Parameters:
/// 	- mocks: Mock objects whose method calling order needs to be verified.
///
/// - Returns: New ``InOrder`` struct.
///
/// ```swift
/// let inOrder = inOrder(firstMock, secondMock)
///
/// inOrder.verify(firstMock).add(eq("was called first"))
/// inOrder.verify(secondMock).add(eq("was called second"))
/// ```
/// Verification in order is flexible - **you don't have to verify all interactions** one-by-one
/// but only those that you are interested in testing in order.
///
/// Also, you can create InOrder object passing only mocks that are relevant for in-order verification.
public func inOrder(_ mocks: AnyObject...) -> InOrder {
	InOrder(mocks)
}
