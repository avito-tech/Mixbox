import MixboxFoundation
import MixboxTestsFoundation

public final class MockManagerFactoryImpl: MockManagerFactory {
    private let testFailureRecorder: TestFailureRecorder
    private let waiter: RunLoopSpinningWaiter
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        waiter: RunLoopSpinningWaiter)
    {
        self.testFailureRecorder = testFailureRecorder
        self.waiter = waiter
    }
    
    public func mockManager() -> MockManager {
        return MockManagerImpl(
            testFailureRecorder: testFailureRecorder,
            waiter: waiter
        )
    }
}
