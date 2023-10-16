public protocol MockVerify {
	associatedtype Mock
	init(mock: Mock, container: CallContainer, times: @escaping TimesMatcher)
}

public protocol Verifiable {
	associatedtype Verify: MockVerify where Verify.Mock == Self
	
	var container: VerifyContainer { get }
}
