public protocol StubsHolder: StubsProvider {
    var stubs: [FunctionIdentifier: [Stub]] { get set }
}
