public protocol StubsProvider: AnyObject {
    var stubs: [FunctionIdentifier: [CallStub]] { get }
}
