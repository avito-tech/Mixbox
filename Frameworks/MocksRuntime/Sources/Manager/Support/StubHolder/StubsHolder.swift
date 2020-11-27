public protocol StubsHolder: StubsProvider {
    var stubs: [FunctionIdentifier: [CallStub]] { get set }
}
