import XCTest
import MixboxTestsFoundation

public final class RegisterMocksSetUpAction: SetUpAction {
    private let testCaseMirror: Mirror
    private let mockRegisterer: MockRegisterer
    
    public init(
        testCaseMirror: Mirror,
        mockRegisterer: MockRegisterer)
    {
        self.testCaseMirror = testCaseMirror
        self.mockRegisterer = mockRegisterer
    }

    public convenience init(
        testCase: XCTestCase,
        mockRegisterer: MockRegisterer)
    {
        self.init(
            testCaseMirror: Mirror(
                reflecting: testCase
            ),
            mockRegisterer: mockRegisterer
        )
    }
    
    public func setUp() -> TearDownAction {
        testCaseMirror.children.forEach { child in
            if let mock = child.value as? StorableMock {
                mockRegisterer.register(mock: mock)
            }
        }
        
        return NoopTearDownAction()
    }
}
