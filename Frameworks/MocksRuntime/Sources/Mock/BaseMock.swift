import MixboxFoundation
import MixboxTestsFoundation

open class BaseMock {
    private var storedMockManager: MockManager?
    private let fileLineWhereInitialized: FileLine
    private let onceToken = ThreadSafeOnceToken<Void>()
    
    public init(
        mockManager: MockManager? = nil,
        file: StaticString = #file,
        line: UInt = #line)
    {
        self.storedMockManager = mockManager
        self.fileLineWhereInitialized = FileLine(file: file, line: line)
    }
    
    // MARK: - Mock
    
    public func getMockManager() -> MockManager {
        return storedMockManager.unwrapOrFail(
            message: { fileLine in
                "`mockManager` was not set, mock \(type(of: self)) has been created on \(fileLine)"
            },
            file: fileLineWhereInitialized.file,
            line: fileLineWhereInitialized.line
        )
    }
    
    public func setMockManager(mockManager: MockManager) {
        onceToken.executeOnce(
            body: {
                storedMockManager = mockManager
            },
            observer: { wasExecuted, _ in
                if !wasExecuted {
                    UnavoidableFailure.fail("You called `setMockManager` twice")
                }
            }
        )
    }
}
