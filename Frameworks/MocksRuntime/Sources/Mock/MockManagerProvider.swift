public protocol MockManagerProvider: AnyObject {
    func getMockManager(_: MixboxMocksRuntimeVoid.Type) -> MockManager
}
