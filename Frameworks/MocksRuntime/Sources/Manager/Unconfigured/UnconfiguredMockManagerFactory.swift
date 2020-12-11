import MixboxFoundation
import MixboxTestsFoundation

/// This factory is to be used for mocks that aren't linked to other dependencies yet,
/// for example, if they are defined as instance properties in a TestCase:
///
/// ```
/// class MyTestCase: ... {
///     let mock = MockService()
/// }
/// ```
///
public final class UnconfiguredMockManagerFactory: MockManagerFactory {
    public init() {
    }
    
    public func mockManager() -> MockManager {
        let configuredMockManagerFactory = ConfiguredMockManagerFactory(
            testFailureRecorder: XcTestFailureRecorder(
                currentTestCaseProvider: AutomaticCurrentTestCaseProvider(),
                shouldNeverContinueTestAfterFailure: false
            ),
            waiter: RunLoopSpinningWaiterImpl(
                runLoopSpinnerFactory: RunLoopSpinnerFactoryImpl(
                    runLoopModesStackProvider: RunLoopModesStackProviderImpl()
                )
            ),
            defaultTimeout: 15, // TODO: Sync values across the project
            defaultPollingInterval: 0.1, // TODO: Sync values across the project
            dynamicCallableFactory: CanNotProvideResultDynamicCallableFactory(
                error: ErrorString(
                    """
                    Mock manager is not configured, can not dynamically provide a result
                    """
                )
            )
        )
        
        return configuredMockManagerFactory.mockManager()
    }
}
