public final class MockRegistererImpl: MockRegisterer {
    private let mockManagerFactory: MockManagerFactory
    
    public init(
        mockManagerFactory: MockManagerFactory)
    {
        self.mockManagerFactory = mockManagerFactory
    }
    
    public func register(mock: StorableMock) {
        mock.setMockManager(
            mockManagerFactory.mockManager()
        )
    }
}
