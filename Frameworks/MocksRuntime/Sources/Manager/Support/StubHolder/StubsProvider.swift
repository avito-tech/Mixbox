public protocol StubsProvider: class {
    var stubs: [FunctionIdentifier: [CallStub]] { get }
}
