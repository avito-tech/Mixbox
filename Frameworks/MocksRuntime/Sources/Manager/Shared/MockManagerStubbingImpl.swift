public final class MockManagerStubbingImpl: MockManagerStubbing {
    private let stubsHolder: StubsHolder
    
    public init(stubsHolder: StubsHolder) {
        self.stubsHolder = stubsHolder
    }
    
    public func stub(
        functionIdentifier: FunctionIdentifier,
        callStub: CallStub)
    {
        stubsHolder.stubs[functionIdentifier, default: []]
            .append(callStub)
    }
}
