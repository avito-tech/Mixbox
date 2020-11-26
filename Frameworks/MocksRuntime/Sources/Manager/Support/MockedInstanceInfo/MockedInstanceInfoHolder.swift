public final class MockedInstanceInfoHolder: MockedInstanceInfoSettable, MockedInstanceInfoProvider {
    private var mockedInstanceInfo: MockedInstanceInfo?
    
    public init() {}
    
    public func getMockedInstanceInfo() -> MockedInstanceInfo? {
        return mockedInstanceInfo
    }
    
    public func setMockedInstanceInfo(_ mockedInstanceInfo: MockedInstanceInfo) {
        self.mockedInstanceInfo = mockedInstanceInfo
    }
}
