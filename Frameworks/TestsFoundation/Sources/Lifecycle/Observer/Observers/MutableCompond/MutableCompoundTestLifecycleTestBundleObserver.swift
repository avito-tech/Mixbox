public final class MutableCompoundTestLifecycleTestBundleObserver: TestLifecycleTestBundleObserver {
    public var testLifecycleTestBundleObservers: [TestLifecycleTestBundleObserver]
    
    public init(testLifecycleTestBundleObservers: [TestLifecycleTestBundleObserver] = []) {
        self.testLifecycleTestBundleObservers = testLifecycleTestBundleObservers
    }
    
    public func onStart(testBundle: Bundle) {
        testLifecycleTestBundleObservers.forEach {
            $0.onStart(testBundle: testBundle)
        }
    }
    
    public func onStop(testBundle: Bundle) {
        testLifecycleTestBundleObservers.forEach {
            $0.onStop(testBundle: testBundle)
        }
    }
}
