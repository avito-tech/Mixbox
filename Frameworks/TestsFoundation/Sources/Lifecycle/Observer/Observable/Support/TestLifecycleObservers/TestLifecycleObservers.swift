// Convenient way to set up everything
public protocol TestLifecycleObservers {
    var testLifecycleTestBundleObserver: TestLifecycleTestBundleObserver { get }
    var testLifecycleTestSuiteObserver: TestLifecycleTestSuiteObserver { get }
    var testLifecycleTestCaseObserver: TestLifecycleTestCaseObserver { get }
}
