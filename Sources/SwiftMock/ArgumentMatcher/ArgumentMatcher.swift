/// A function type that tests the value of an argument to a called function.
///
/// When you call a method on a mock type, the mock checks the ``MethodInvoction``
/// array and checks each argument using the ``ArgumentMatcher``. If all arguments
/// pass the test, then this ``MethodInvocation`` is considered suitable. It is removed
/// from the array and its data is used to return the method's value.
public typealias ArgumentMatcher<Argument> = (Argument) -> Bool

