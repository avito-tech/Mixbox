public protocol MockRegisterer: class {
    func register(mock: MockManagerSettable)
}

extension MockRegisterer {
    public func register<Mock: MixboxMocksRuntime.Mock>(_ mock: Mock) -> Mock {
        self.register(mock: mock)
        return mock
    }
}
