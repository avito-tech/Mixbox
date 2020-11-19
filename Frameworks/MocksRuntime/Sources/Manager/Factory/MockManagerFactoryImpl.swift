import MixboxTestsFoundation

public final class MockManagerFactoryImpl: MockManagerFactory {
    private let testFailureRecorder: TestFailureRecorder
    
    public init(testFailureRecorder: TestFailureRecorder) {
        self.testFailureRecorder = testFailureRecorder
    }
    
    public func mockManager() -> MockManager {
        return MockManagerImpl(
            testFailureRecorder: testFailureRecorder
        )
    }
}
