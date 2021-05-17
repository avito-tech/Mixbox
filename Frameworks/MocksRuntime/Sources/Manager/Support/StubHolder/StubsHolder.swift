public protocol StubsHolder: StubsProvider {
    // Applies `modify` block to stubs and return it. Thread-safe.
    @discardableResult
    func modifyStubs(
        modify: (inout [FunctionIdentifier: [CallStub]]) -> ())
        -> [FunctionIdentifier: [CallStub]]
}

extension StubsHolder {
    public var stubs: [FunctionIdentifier : [CallStub]] {
        modifyStubs { _ in }
    }
}
