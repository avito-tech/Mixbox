import MixboxFoundation
import MixboxTestsFoundation

open class BaseMock: MockManagerSettable {
    private var mockManager: MockManager
    private let fileLineWhereInitialized: FileLine
    
    public init(
        mockManager: MockManager = UnconfiguredMockManagerFactory().mockManager(),
        file: StaticString = #file,
        line: UInt = #line)
    {
        self.mockManager = mockManager
        self.fileLineWhereInitialized = FileLine(file: file, line: line)
        
        mockManager.setMockedInstanceInfo(mockedInstanceInfo())
    }
    
    // MARK: - Mock
    
    public func getMockManager() -> MockManager {
        return mockManager
    }
    
    public func setMockManager(
        _ newMockManager: MockManager)
        -> MixboxMocksRuntimeVoid
    {
        let oldMockManager = self.mockManager
        
        newMockManager.setMockedInstanceInfo(mockedInstanceInfo())
        oldMockManager.transferState(to: newMockManager)
        
        self.mockManager = newMockManager
        
        return MixboxMocksRuntimeVoid()
    }
    
    private func mockedInstanceInfo() -> MockedInstanceInfo {
        return MockedInstanceInfo(
            type: type(of: self),
            mirror: Mirror(reflecting: self),
            fileLineWhereInitialized: fileLineWhereInitialized
        )
    }
}
