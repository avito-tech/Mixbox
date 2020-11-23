public final class MockRegistererImpl: MockRegisterer {
    private let mockManagerFactory: MockManagerFactory
    
    public init(
        mockManagerFactory: MockManagerFactory)
    {
        self.mockManagerFactory = mockManagerFactory
    }
    
    public func register(mock: MockManagerSettable) {
        mock.setMockManager(
            mockManagerFactory.mockManager()
        )
    }
}
