import MixboxFoundation
import MixboxTestsFoundation

public final class ConfiguredMockManagerFactory: MockManagerFactory {
    private let testFailureRecorder: TestFailureRecorder
    private let waiter: RunLoopSpinningWaiter
    private let defaultTimeout: TimeInterval
    private let defaultPollingInterval: TimeInterval
    private let dynamicCallableFactory: DynamicCallableFactory
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        waiter: RunLoopSpinningWaiter,
        defaultTimeout: TimeInterval,
        defaultPollingInterval: TimeInterval,
        dynamicCallableFactory: DynamicCallableFactory)
    {
        self.testFailureRecorder = testFailureRecorder
        self.waiter = waiter
        self.defaultTimeout = defaultTimeout
        self.defaultPollingInterval = defaultPollingInterval
        self.dynamicCallableFactory = dynamicCallableFactory
    }
    
    public func mockManager() -> MockManager {
        let stubsHolder = StubsHolderImpl()
        let recordedCallsHolder = RecordedCallsHolderImpl()
        
        return MockManagerImpl(
            stubbing: MockManagerStubbingImpl(
                stubsHolder: stubsHolder
            ),
            calling: MockManagerCallingImpl(
                testFailureRecorder: testFailureRecorder,
                recordedCallsHolder: recordedCallsHolder,
                stubsProvider: stubsHolder,
                dynamicCallableFactory: dynamicCallableFactory
            ),
            verification: MockManagerVerificationImpl(
                testFailureRecorder: testFailureRecorder,
                recordedCallsProvider: recordedCallsHolder,
                waiter: waiter,
                defaultTimeout: defaultTimeout,
                defaultPollingInterval: defaultPollingInterval
            ),
            stateTransferring: MockManagerStateTransferringImpl(
                stubsProvider: stubsHolder,
                recordedCallsHolder: recordedCallsHolder
            )
        )
    }
}
