import Foundation

/// Enables stubbing methods. Use it when you want the mock to return particular value when particular method is called.
///
/// Simply put: "*when* the x method is called *then* return y".
///
/// Examples:
///
/// ~~~
/// when(mock.$someMethod()).thenReturn(10)
/// ~~~
///
/// You can use flexible argument matchers, e.g:
/// ~~~
/// when(mock.$someMethod(argument: any())).thenReturn(10)
///	~~~
///
/// Setting exception to be thrown:
/// ~~~
/// when(mock.$someMethod(argument: eq("some arg"))).thenThrow(SomeError.error)
/// ~~~
///
/// You can set different behavior for consecutive method calls.
/// Last stubbing (e.g: thenReturn("foo")) determines the behavior of further consecutive calls.
/// ~~~
/// when(mock.$someMethod(argument: eq("some arg")))
/// 	.thenThrow(SomeError.error)
/// 	.thenReturn("foo")
/// ~~~
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
/// ~~~
/// when(mock.$someMethod()).thenReturn(10)
/// ~~~
///
/// You can use flexible argument matchers, e.g:
/// ~~~
/// when(mock.$someMethod(argument: any())).thenReturn(10)
///	~~~
///
/// Setting exception to be thrown:
/// ~~~
/// when(mock.$someMethod(argument: eq("some arg"))).thenThrow(SomeError.error)
/// ~~~
///
/// You can set different behavior for consecutive method calls.
/// Last stubbing (e.g: thenReturn("foo")) determines the behavior of further consecutive calls.
/// ~~~
/// when(mock.$someMethod(argument: eq("some arg")))
/// 	.thenThrow(SomeError.error)
/// 	.thenReturn("foo")
/// ~~~
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
/// ~~~
/// when(mock.$someMethod()).thenReturn(10)
/// ~~~
///
/// You can use flexible argument matchers, e.g:
/// ~~~
/// when(mock.$someMethod(argument: any())).thenReturn(10)
///	~~~
///
/// Setting exception to be thrown:
/// ~~~
/// when(mock.$someMethod(argument: eq("some arg"))).thenThrow(SomeError.error)
/// ~~~
///
/// You can set different behavior for consecutive method calls.
/// Last stubbing (e.g: thenReturn("foo")) determines the behavior of further consecutive calls.
/// ~~~
/// when(mock.$someMethod(argument: eq("some arg")))
/// 	.thenThrow(SomeError.error)
/// 	.thenReturn("foo")
/// ~~~
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
/// ~~~
/// when(mock.$someMethod()).thenReturn(10)
/// ~~~
///
/// You can use flexible argument matchers, e.g:
/// ~~~
/// when(mock.$someMethod(argument: any())).thenReturn(10)
///	~~~
///
/// Setting exception to be thrown:
/// ~~~
/// when(mock.$someMethod(argument: eq("some arg"))).thenThrow(SomeError.error)
/// ~~~
///
/// You can set different behavior for consecutive method calls.
/// Last stubbing (e.g: thenReturn("foo")) determines the behavior of further consecutive calls.
/// ~~~
/// when(mock.$someMethod(argument: eq("some arg")))
/// 	.thenThrow(SomeError.error)
/// 	.thenReturn("foo")
/// ~~~
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
