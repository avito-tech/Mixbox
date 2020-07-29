import MixboxTestsFoundation
import TestsIpc

public final class MeasureableTimedActivityMetricSenderWaiterTestLifecycleManager:
    TestLifecycleManager
{
    public init() {
    }
    
    // MARK: - TestLifecycleManager
    
    public func startObserving(testLifecycleObservable: TestLifecycleObservable) {
        let testLifecycleObserver = TestLifecycleObserver()
        
        testLifecycleObserver.testBundleObserver.onStop = { _ in
            Singletons.measureableTimedActivityMetricSenderWaiter.waitForAllMetricsAreSent()
        }
        
        testLifecycleObservable.addObserver(testLifecycleObserver)
    }
}
