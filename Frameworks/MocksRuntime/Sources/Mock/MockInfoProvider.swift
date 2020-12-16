public protocol MockInfoProvider: class {
    func getMockInfo(_: MixboxMocksRuntimeVoid.Type) -> MockInfo
}
