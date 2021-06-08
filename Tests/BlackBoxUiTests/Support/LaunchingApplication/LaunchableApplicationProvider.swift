import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxBlack
import MixboxSBTUITestTunnelClient
import MixboxFoundation

public final class LaunchableApplicationProvider {
    public var shouldCreateLaunchableApplicationWithBuiltinIpc = false
    
    public var launchableApplication: LaunchableApplication {
        return reusedLaunchableApplication()
            ?? createLaunchableApplication()
    }
    
    private let applicationLifecycleObservable: ApplicationLifecycleObservable & ApplicationLifecycleObserver
    private let testFailureRecorder: TestFailureRecorder
    private let bundleResourcePathProvider: BundleResourcePathProvider
    private let waiter: RunLoopSpinningWaiter
    private let performanceLogger: PerformanceLogger
    private let bundleId: String
    
    public init(
        applicationLifecycleObservable: ApplicationLifecycleObservable & ApplicationLifecycleObserver,
        testFailureRecorder: TestFailureRecorder,
        bundleResourcePathProvider: BundleResourcePathProvider,
        waiter: RunLoopSpinningWaiter,
        performanceLogger: PerformanceLogger,
        bundleId: String)
    {
        self.applicationLifecycleObservable = applicationLifecycleObservable
        self.testFailureRecorder = testFailureRecorder
        self.bundleResourcePathProvider = bundleResourcePathProvider
        self.waiter = waiter
        self.performanceLogger = performanceLogger
        self.bundleId = bundleId
    }
    
    private var launchableApplicationWasCreatedWithBuiltinIpc = false
    private var launchableApplicationOrNil: LaunchableApplication?
    
    private func reusedLaunchableApplication() -> LaunchableApplication? {
        guard let launchableApplication = launchableApplicationOrNil else {
            return nil
        }
        
        guard launchableApplicationWasCreatedWithBuiltinIpc == shouldCreateLaunchableApplicationWithBuiltinIpc else {
            UnavoidableFailure.fail(
                """
                Conflicting settings for creating launchable application. \
                launchableApplicationWasCreatedWithBuiltinIpc: \(launchableApplicationWasCreatedWithBuiltinIpc) \
                shouldCreateLaunchableApplicationWithBuiltinIpc: \(shouldCreateLaunchableApplicationWithBuiltinIpc)
                """
            )
        }
            
        return launchableApplication
    }
    
    private func createLaunchableApplication() -> LaunchableApplication {
        let launchableApplication: LaunchableApplication
        
        if shouldCreateLaunchableApplicationWithBuiltinIpc {
            launchableApplication = BuiltinIpcLaunchableApplication(
                applicationLifecycleObservable: applicationLifecycleObservable
            )
        } else {
            launchableApplication = SbtuiLaunchableApplication(
                tunneledApplication: SBTUITunneledApplication(
                    bundleId: bundleId,
                    shouldInstallApplication: true
                ),
                applicationLifecycleObservable: applicationLifecycleObservable,
                testFailureRecorder: testFailureRecorder,
                bundleResourcePathProvider: bundleResourcePathProvider,
                waiter: waiter,
                networkReplayingObserver: DummyNetworkReplayingObserver(),
                performanceLogger: performanceLogger
            )
        }
        
        launchableApplicationOrNil = launchableApplication
        launchableApplicationWasCreatedWithBuiltinIpc = shouldCreateLaunchableApplicationWithBuiltinIpc
        
        return launchableApplication
    }
}
