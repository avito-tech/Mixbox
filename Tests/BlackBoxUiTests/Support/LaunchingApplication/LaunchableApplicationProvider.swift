import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxBlack
import MixboxFoundation

public final class LaunchableApplicationProvider {
    public var launchableApplication: LaunchableApplication {
        return reusedLaunchableApplication()
            ?? createLaunchableApplication()
    }
    
    private let applicationLifecycleObservable: ApplicationLifecycleObservable & ApplicationLifecycleObserver
    private let testFailureRecorder: TestFailureRecorder
    private let bundleResourcePathProvider: BundleResourcePathProvider
    private let waiter: RunLoopSpinningWaiter
    private let performanceLogger: PerformanceLogger
    private let legacyNetworking: LegacyNetworking
    
    public init(
        applicationLifecycleObservable: ApplicationLifecycleObservable & ApplicationLifecycleObserver,
        testFailureRecorder: TestFailureRecorder,
        bundleResourcePathProvider: BundleResourcePathProvider,
        waiter: RunLoopSpinningWaiter,
        performanceLogger: PerformanceLogger,
        legacyNetworking: LegacyNetworking)
    {
        self.applicationLifecycleObservable = applicationLifecycleObservable
        self.testFailureRecorder = testFailureRecorder
        self.bundleResourcePathProvider = bundleResourcePathProvider
        self.waiter = waiter
        self.performanceLogger = performanceLogger
        self.legacyNetworking = legacyNetworking
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
        let launchableApplication: LaunchableApplication = BuiltinIpcLaunchableApplication(
            legacyNetworking: legacyNetworking,
            applicationLifecycleObservable: applicationLifecycleObservable
        )
        
        launchableApplicationOrNil = launchableApplication
        
        return launchableApplication
    }
}
