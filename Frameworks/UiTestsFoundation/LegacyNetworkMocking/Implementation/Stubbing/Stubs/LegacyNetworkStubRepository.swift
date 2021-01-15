public protocol LegacyNetworkStubRepository {
    func add(stub: LegacyNetworkStub)
    func removeAllStubs()
}
