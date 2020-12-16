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
    }
    
    // MARK: - Mock
    
    public func getMockManager(_: MixboxMocksRuntimeVoid.Type) -> MockManager {
        return mockManager
    }
    
    @discardableResult
    public func setMockManager(
        _ newMockManager: MockManager)
        -> MixboxMocksRuntimeVoid
    {
        let oldMockManager = self.mockManager
        
        oldMockManager.transferState(to: newMockManager)
        
        self.mockManager = newMockManager
        
        return MixboxMocksRuntimeVoid()
    }
}
