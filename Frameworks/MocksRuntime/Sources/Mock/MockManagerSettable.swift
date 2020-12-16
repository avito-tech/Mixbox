// TODO: Replace with `setMockManagerFactory`? This will make it less likely to
// set same `mockManager` to multiple instances.
public protocol MockManagerSettable: class {
    @discardableResult
    func setMockManager(_ mockManager: MockManager) -> MixboxMocksRuntimeVoid
}
