import MixboxTestsFoundation
import TestsIpc

public final class MeasureableTimedActivityMetricSenderWaiterTestLifecycleManager:
    TestLifecycleManager
{
    public init() {
    }
    
    // MARK: - TestLifecycleManager
    
    public func startObserving(testLifecycleObservable: TestLifecycleObservable) {
        let testLifecycleTestBundleObserver = MutableClosuresTestLifecycleTestBundleObserver()
        
        testLifecycleTestBundleObserver.onStop = { _ in
            Singletons.measureableTimedActivityMetricSenderWaiter.waitForAllMetricsAreSent()
        }
        
        testLifecycleObservable.add(testLifecycleTestBundleObserver: testLifecycleTestBundleObserver)
    }
}
