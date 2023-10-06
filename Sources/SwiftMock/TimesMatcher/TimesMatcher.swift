/// A function type that tests the function call count.
///
/// When you verify a method on a mock type, the mock checks the MethodCall
/// array and checks each argument using the ``ArgumentMatcher``. If count
/// of calls do not pass ``TimesMatcher`` function, than test fail.
public typealias TimesMatcher = (Int) -> Bool
