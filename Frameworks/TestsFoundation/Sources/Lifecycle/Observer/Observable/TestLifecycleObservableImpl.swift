// Note: Thread unsafe (observation is set up from main thread anyway)
public final class TestLifecycleObservableImpl: TestLifecycleObservable {
    private var testLifecycleObserverTestObservation: TestLifecycleObserverTestObservation?
    
    private let mutableCompoundTestLifecycleTestBundleObserver = MutableCompoundTestLifecycleTestBundleObserver()
    private let mutableCompoundTestLifecycleTestSuiteObserver = MutableCompoundTestLifecycleTestSuiteObserver()
    private let mutableCompoundTestLifecycleTestCaseObserver = MutableCompoundTestLifecycleTestCaseObserver()
    
    public init() {
    }
    
    deinit {
        if let testLifecycleObserverTestObservation = testLifecycleObserverTestObservation {
            XCTestObservationCenter.shared.removeTestObserver(testLifecycleObserverTestObservation)
        }
    }
    
    public func add(testLifecycleTestBundleObserver: TestLifecycleTestBundleObserver) {
        setUpObservation()
        mutableCompoundTestLifecycleTestBundleObserver.testLifecycleTestBundleObservers.append(testLifecycleTestBundleObserver)
        
    }
    
    public func add(testLifecycleTestSuiteObserver: TestLifecycleTestSuiteObserver) {
        setUpObservation()
        mutableCompoundTestLifecycleTestSuiteObserver.testLifecycleTestSuiteObservers.append(testLifecycleTestSuiteObserver)
    }
    
    public func add(testLifecycleTestCaseObserver: TestLifecycleTestCaseObserver) {
        setUpObservation()
        mutableCompoundTestLifecycleTestCaseObserver.testLifecycleTestCaseObservers.append(testLifecycleTestCaseObserver)
    }
    
    private func setUpObservation() {
        if testLifecycleObserverTestObservation == nil {
            let testLifecycleObserverTestObservation = TestLifecycleObserverTestObservation(
                testLifecycleTestBundleObserver: mutableCompoundTestLifecycleTestBundleObserver,
                testLifecycleTestSuiteObserver: mutableCompoundTestLifecycleTestSuiteObserver,
                testLifecycleTestCaseObserver: mutableCompoundTestLifecycleTestCaseObserver
            )
            
            XCTestObservationCenter.shared.addTestObserver(testLifecycleObserverTestObservation)
            
            self.testLifecycleObserverTestObservation = testLifecycleObserverTestObservation
        }
    }
}
