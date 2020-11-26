import MixboxFoundation
import MixboxTestsFoundation

public final class ConfiguredMockManagerFactory: MockManagerFactory {
    private let testFailureRecorder: TestFailureRecorder
    private let waiter: RunLoopSpinningWaiter
    private let defaultTimeout: TimeInterval
    private let defaultPollingInterval: TimeInterval
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        waiter: RunLoopSpinningWaiter,
        defaultTimeout: TimeInterval,
        defaultPollingInterval: TimeInterval)
    {
        self.testFailureRecorder = testFailureRecorder
        self.waiter = waiter
        self.defaultTimeout = defaultTimeout
        self.defaultPollingInterval = defaultPollingInterval
    }
    
    public func mockManager() -> MockManager {
        let stubsHolder = StubsHolderImpl()
        let callRecordsHolder = CallRecordsHolderImpl()
        
        let mockedInstanceInfoHolder = MockedInstanceInfoHolder()
        
        return MockManagerImpl(
            stubbing: MockManagerStubbingImpl(
                stubsHolder: stubsHolder
            ),
            calling: MockManagerCallingImpl(
                testFailureRecorder: testFailureRecorder,
                callRecordsHolder: callRecordsHolder,
                stubsProvider: stubsHolder
            ),
            verification: MockManagerVerificationImpl(
                testFailureRecorder: testFailureRecorder,
                callRecordsProvider: callRecordsHolder,
                waiter: waiter,
                defaultTimeout: defaultTimeout,
                defaultPollingInterval: defaultPollingInterval
            ),
            stateTransferring: MockManagerStateTransferringImpl(
                stubsProvider: stubsHolder,
                callRecordsHolder: callRecordsHolder
            ),
            mockedInstanceInfoSettable: mockedInstanceInfoHolder
        )
    }
}
