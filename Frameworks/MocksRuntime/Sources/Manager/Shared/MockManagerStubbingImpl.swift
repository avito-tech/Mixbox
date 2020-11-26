public final class MockManagerStubbingImpl: MockManagerStubbing {
    private let stubsHolder: StubsHolder
    
    public init(stubsHolder: StubsHolder) {
        self.stubsHolder = stubsHolder
    }
    
    public func stub<Arguments>(
        functionIdentifier: FunctionIdentifier,
        closure: @escaping (Any) -> Any,
        argumentsMatcher: FunctionalMatcher<Arguments>)
    {
        let stub = Stub(
            closure: closure,
            matcher: argumentsMatcher.byErasingType()
        )
        stubsHolder.stubs[functionIdentifier, default: []].append(stub)
    }
}
