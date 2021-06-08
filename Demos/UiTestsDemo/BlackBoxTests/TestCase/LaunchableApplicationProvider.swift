import MixboxFoundation
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxBlack
import MixboxSBTUITestTunnelClient

// There are many options for you of how to start your app (there are 3 projects in total that do it differently,
// like handling launch arguments, environment, some other things).
// There is no reusable code in Mixbox yet that will do this for you, so at the moment you have to copypaste this
// into your project.
public final class LaunchableApplicationProvider {
    public var launchableApplication: LaunchableApplication {
        return reusedLaunchableApplication()
            ?? createLaunchableApplication()
    }
    
    private let applicationLifecycleObservable: ApplicationLifecycleObservable & ApplicationLifecycleObserver
    private let testFailureRecorder: TestFailureRecorder
    private let bundleResourcePathProvider: BundleResourcePathProvider
    private let waiter: RunLoopSpinningWaiter
    private let bundleId: String
    
    public init(
        applicationLifecycleObservable: ApplicationLifecycleObservable & ApplicationLifecycleObserver,
        testFailureRecorder: TestFailureRecorder,
        bundleResourcePathProvider: BundleResourcePathProvider,
        waiter: RunLoopSpinningWaiter,
        bundleId: String)
    {
        self.applicationLifecycleObservable = applicationLifecycleObservable
        self.testFailureRecorder = testFailureRecorder
        self.bundleResourcePathProvider = bundleResourcePathProvider
        self.waiter = waiter
        self.bundleId = bundleId
    }
    
    private var launchableApplicationWasCreatedWithBuiltinIpc = false
    private var launchableApplicationOrNil: LaunchableApplication?
    
    private func reusedLaunchableApplication() -> LaunchableApplication? {
        guard let launchableApplication = launchableApplicationOrNil else {
            return nil
        }
            
        return launchableApplication
    }
    
    private func createLaunchableApplication() -> LaunchableApplication {
        let launchableApplication = SbtuiLaunchableApplication(
            tunneledApplication: SBTUITunneledApplication(
                bundleId: bundleId,
                shouldInstallApplication: true
            ),
            applicationLifecycleObservable: applicationLifecycleObservable,
            testFailureRecorder: testFailureRecorder,
            bundleResourcePathProvider: bundleResourcePathProvider,
            waiter: waiter,
            networkReplayingObserver: DummyNetworkReplayingObserver(),
            performanceLogger: NoopPerformanceLogger()
        )
        
        launchableApplicationOrNil = launchableApplication
        
        return launchableApplication
    }
}
