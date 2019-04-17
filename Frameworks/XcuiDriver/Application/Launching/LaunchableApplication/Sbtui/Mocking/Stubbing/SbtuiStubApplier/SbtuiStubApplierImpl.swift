import SBTUITestTunnel
import MixboxXcuiDriver

public final class SbtuiStubApplierImpl: SbtuiStubApplier, ApplicationLifecycleObserver {
    private let tunneledApplication: SBTUITunneledApplication
    private let applicationLifecycleObservable: ApplicationLifecycleObservable
    private var stubsToApply: [SbtuiStub] = []
    private var tunnelIsLaunched = false
    
    public init(
        tunneledApplication: SBTUITunneledApplication,
        applicationLifecycleObservable: ApplicationLifecycleObservable)
    {
        self.tunneledApplication = tunneledApplication
        self.applicationLifecycleObservable = applicationLifecycleObservable
        
        applicationLifecycleObservable.addObserver(self)
    }
    
    // MARK: - ApplicationLifecycleObserver
    
    public func apply(stub: SbtuiStub) {
        if applicationLifecycleObservable.applicationIsLaunched {
            stubRequestsInTunneledApplication(stub: stub)
        }
        
        stubsToApply.append(stub)
    }
    
    public func removeAllStubs() {
        stubsToApply = []
        tunneledApplication.stubRequestsRemoveAll()
    }
    
    // MARK: - ApplicationLifecycleObserver
    
    public func applicationStateChanged(applicationIsLaunched: Bool) {
        tunnelIsLaunched = applicationIsLaunched
        
        if applicationIsLaunched {
            stubsToApply.forEach { stub in
                stubRequestsInTunneledApplication(stub: stub)
            }
        }
    }
    
    // MARK: - Private
    
    private func stubRequestsInTunneledApplication(stub: SbtuiStub) {
        tunneledApplication.stubRequests(
            matching: stub.requestMatch,
            response: stub.stubResponse
        )
    }
}
