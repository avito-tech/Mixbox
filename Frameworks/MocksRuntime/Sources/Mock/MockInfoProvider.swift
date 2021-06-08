public protocol MockInfoProvider: AnyObject {
    func getMockInfo(_: MixboxMocksRuntimeVoid.Type) -> MockInfo
}
