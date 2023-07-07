import XCTest

public protocol TestLifecycleObservable: AnyObject {
    func add(testLifecycleTestBundleObserver: TestLifecycleTestBundleObserver)
    func add(testLifecycleTestSuiteObserver: TestLifecycleTestSuiteObserver)
    func add(testLifecycleTestCaseObserver: TestLifecycleTestCaseObserver)
}

extension TestLifecycleObservable {
    public func add(testLifecycleObservers: TestLifecycleObservers) {
        add(testLifecycleTestBundleObserver: testLifecycleObservers.testLifecycleTestBundleObserver)
        add(testLifecycleTestSuiteObserver: testLifecycleObservers.testLifecycleTestSuiteObserver)
        add(testLifecycleTestCaseObserver: testLifecycleObservers.testLifecycleTestCaseObserver)
    }
}
