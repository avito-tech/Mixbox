import MixboxUiTestsFoundation
import MixboxXcuiDriver
import SBTUITestTunnel
import MixboxIpcSbtuiClient
import MixboxReporting

public final class SbtuiLaunchableApplication: LaunchableApplication {
    public let networking: Networking
    
    private let tunneledApplication = SBTUITunneledApplication()
    private let applicationDidLaunchObserver: ApplicationDidLaunchObserver
    private let testFailureRecorder: TestFailureRecorder
    private let sbtuiStubApplier: SbtuiStubApplier
    
    public init(
        applicationDidLaunchObserver: ApplicationDidLaunchObserver,
        testFailureRecorder: TestFailureRecorder)
    {
        self.applicationDidLaunchObserver = applicationDidLaunchObserver
        self.testFailureRecorder = testFailureRecorder
        self.sbtuiStubApplier = SbtuiStubApplier(
            tunneledApplication: tunneledApplication
        )
        
        networking = NetworkingImpl(
            stubbing: SbtuiStubRequestBuilder(
                sbtuiStubApplier: sbtuiStubApplier,
                testFailureRecorder: testFailureRecorder
            ),
            recording: SbtuiNetworkRecordsProvider(
                tunneledApplication:  tunneledApplication
            )
        )
    }
    
    public func launch(environment: [String: String]) -> LaunchedApplication {
        // Note that setting it to a value > Int32.max would lead to an error.
        let timeoutValueThatReallyDisablesTimeout: TimeInterval = 100000
        SBTUITunneledApplication.setConnectionTimeout(timeoutValueThatReallyDisablesTimeout)
        
        for (key, value) in environment {
            tunneledApplication.launchEnvironment[key] = value
        }
        
        tunneledApplication.launchTunnel { [applicationDidLaunchObserver, sbtuiStubApplier] in
            applicationDidLaunchObserver.applicationDidLaunch()
            sbtuiStubApplier.handleTunnelIsLaunched()
        }
        
        return LaunchedApplicationImpl(
            ipcClient: SbtuiIpcClient(
                application: tunneledApplication
            ),
            ipcRouter: nil
        )
    }
}
