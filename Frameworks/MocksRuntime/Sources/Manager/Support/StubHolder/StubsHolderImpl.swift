public final class StubsHolderImpl: StubsHolder {
    public var stubs: [FunctionIdentifier: [CallStub]] = [:]
    
    public init() {
    }
}
