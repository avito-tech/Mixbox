import SBTUITestTunnel

// TODO: Replace handleTunnelIsLaunched() and handleTunnelIsTerminated()
// with ApplicationDidLaunchObservable, rename it to something like ApplicationLifecycleObservable.
public final class SbtuiStubApplier {
    private let tunneledApplication: SBTUITunneledApplication
    private var stubs: [SbtuiStub] = []
    private var tunnelIsLaunched = false
    
    public init(tunneledApplication: SBTUITunneledApplication) {
        self.tunneledApplication = tunneledApplication
    }
    
    public func apply(stub: SbtuiStub) {
        if tunnelIsLaunched {
            tunneledApplication.stubRequests(
                matching: stub.requestMatch,
                response: stub.stubResponse
            )
        } else {
            stubs.append(stub)
        }
    }
    
    public func handleTunnelIsLaunched() {
        tunnelIsLaunched = true
        
        stubs.forEach { stub in
            apply(stub: stub)
        }
        
        stubs.removeAll()
    }
    
    public func handleTunnelIsTerminated() {
        tunnelIsLaunched = false
    }
    
    public func removeAllStubs() {
        tunneledApplication.stubRequestsRemoveAll()
    }
}
