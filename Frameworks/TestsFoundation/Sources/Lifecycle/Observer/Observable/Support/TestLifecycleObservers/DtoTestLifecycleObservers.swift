public final class DtoTestLifecycleObservers: TestLifecycleObservers {
    public var testLifecycleTestBundleObserver: TestLifecycleTestBundleObserver
    public var testLifecycleTestSuiteObserver: TestLifecycleTestSuiteObserver
    public var testLifecycleTestCaseObserver: TestLifecycleTestCaseObserver
    
    public init(
        testLifecycleTestBundleObserver: TestLifecycleTestBundleObserver,
        testLifecycleTestSuiteObserver: TestLifecycleTestSuiteObserver,
        testLifecycleTestCaseObserver: TestLifecycleTestCaseObserver
    ) {
        self.testLifecycleTestBundleObserver = testLifecycleTestBundleObserver
        self.testLifecycleTestSuiteObserver = testLifecycleTestSuiteObserver
        self.testLifecycleTestCaseObserver = testLifecycleTestCaseObserver
    }
}
