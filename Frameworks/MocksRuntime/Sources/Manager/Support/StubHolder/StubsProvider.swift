public protocol StubsProvider: class {
    var stubs: [FunctionIdentifier: [Stub]] { get }
}
