public protocol MockVerify {
	associatedtype Mock
	init(mock: Mock, times: @escaping TimesMatcher)
}

public protocol Verifiable {
	associatedtype Verify: MockVerify where Verify.Mock == Self
}
