import SBTUITestTunnel
import MixboxFoundation

public final class SbtuiStubApplierImpl: SbtuiStubApplier, ApplicationLifecycleObserver {
    private let tunneledApplication: SBTUITunneledApplication
    private var stubsToApply: [SbtuiStub] = [] {
        didSet {
            subscribeToApplicationLifecycleOnce()
        }
    }
    
    private let applicationLifecycleObservable: ApplicationLifecycleObservable
    private let subscribeToApplicationLifecycleOnceToken = ThreadUnsafeOnceToken<Void>()
    
    // Unfortunately SBTUITestTunnel doesn't overwrite stubs, so we make every stub unique
    private var indexToMakeRegularExpressionUnique: Int = 0
    
    public init(
        tunneledApplication: SBTUITunneledApplication,
        applicationLifecycleObservable: ApplicationLifecycleObservable)
    {
        self.tunneledApplication = tunneledApplication
        self.applicationLifecycleObservable = applicationLifecycleObservable
    }
    
    // MARK: - SbtuiStubApplier
    
    public func apply(stub: SbtuiStub) {
        stubsToApply.append(stub)
        flush()
    }
    
    public func removeAllStubs() {
        stubsToApply = []
        
        if applicationLifecycleObservable.applicationIsLaunched {
            tunneledApplication.stubRequestsRemoveAll()
        }
    }
    
    private func flush() {
        if applicationLifecycleObservable.applicationIsLaunched {
            stubsToApply
                .forEach { stub in
                    let request = SbtuiStubRequest(
                        urlPattern: stub.request.urlPattern + "(\(indexToMakeRegularExpressionUnique)){0}",
                        httpMethod: stub.request.httpMethod
                    )
                    indexToMakeRegularExpressionUnique += 1
                    tunneledApplication.stubRequests(
                        matching: request.requestMatch,
                        response: stub.response.stubResponse
                    )
                }
            
            stubsToApply = []
        }
    }
    
    // MARK: - ApplicationLifecycleObserver
    
    public func applicationStateChanged(applicationIsLaunched: Bool) {
        if applicationIsLaunched {
            flush()
        }
    }
    
    // MARK: - Private
    
    private func subscribeToApplicationLifecycleOnce() {
        _ = subscribeToApplicationLifecycleOnceToken.executeOnce {
            applicationLifecycleObservable.addObserver(self)
        }
    }
}
