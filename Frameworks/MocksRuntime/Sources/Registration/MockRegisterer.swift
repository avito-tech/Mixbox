public protocol MockRegisterer: class {
    func register(mock: StorableMock)
}

extension MockRegisterer {
    public func register<Mock: MixboxMocksRuntime.Mock>(_ mock: Mock) -> Mock {
        self.register(mock: mock)
        
        return mock
    }
}
