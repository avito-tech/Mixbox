public protocol MockManagerProvider: class {
    func getMockManager(_: MixboxMocksRuntimeVoid.Type) -> MockManager
}
