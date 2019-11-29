import MixboxDi
import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxInAppServices

public final class MixboxGrayDependencies: DependencyCollectionRegisterer {
    private let mixboxUiTestsFoundationDependencies: MixboxUiTestsFoundationDependencies
    
    public init(mixboxUiTestsFoundationDependencies: MixboxUiTestsFoundationDependencies) {
        self.mixboxUiTestsFoundationDependencies = mixboxUiTestsFoundationDependencies
    }
    
    // swiftlint:disable:next function_body_length
    public func register(dependencyRegisterer di: DependencyRegisterer) {
        mixboxUiTestsFoundationDependencies.register(dependencyRegisterer: di)
        
        di.register(type: ApplicationFrameProvider.self) { _ in
            GrayApplicationFrameProvider()
        }
        di.register(type: WindowsProvider.self) { di in
            WindowsProviderImpl(
                application: UIApplication.shared,
                iosVersionProvider: try di.resolve()
            )
        }
        di.register(type: ScreenshotTaker.self) { di in
            GrayScreenshotTaker(
                windowsProvider: try di.resolve(),
                screen: UIScreen.main
            )
        }
        di.register(type: ElementFinder.self) { di in
            UiKitHierarchyElementFinder(
                ipcClient: try di.resolve(),
                testFailureRecorder: try di.resolve(),
                stepLogger: try di.resolve(),
                screenshotTaker: try di.resolve(),
                signpostActivityLogger: try di.resolve(),
                dateProvider: try di.resolve()
            )
        }
        di.register(type: ApplicationQuiescenceWaiter.self) { di in
            GrayApplicationQuiescenceWaiter(
                waiter: try di.resolve(),
                idlingResource: CompoundIdlingResource(
                    idlingResources: [
                        IdlingResourceObjectTracker.instance
                    ]
                )
            )
        }
        di.register(type: PageObjectDependenciesFactory.self) { di in
            GrayPageObjectDependenciesFactory(
                testFailureRecorder: try di.resolve(),
                ipcClient: try di.resolve(),
                stepLogger: try di.resolve(),
                pollingConfiguration: try di.resolve(),
                elementFinder: try di.resolve(),
                screenshotTaker: try di.resolve(),
                windowsProvider: try di.resolve(),
                waiter: try di.resolve(),
                signpostActivityLogger: try di.resolve(),
                snapshotsDifferenceAttachmentGenerator: try di.resolve(),
                snapshotsComparatorFactory: try di.resolve(),
                applicationQuiescenceWaiter: try di.resolve()
            )
        }
        
        // TODO: Use it.
        di.register(type: EventGenerator.self) { di in
            GrayEventGenerator(
                touchPerformer: try di.resolve(),
                windowForPointProvider: try di.resolve(),
                pathGestureUtils: PathGestureUtilsFactoryImpl().pathGestureUtils()
            )
        }
        di.register(type: TouchPerformer.self) { di in
            TouchPerformerImpl(
                multiTouchCommandExecutor: try di.resolve()
            )
        }
        di.register(type: MultiTouchCommandExecutor.self) { di in
            MultiTouchCommandExecutorImpl(
                touchInjectorFactory: try di.resolve()
            )
        }
        di.register(type: WindowForPointProvider.self) { di in
            WindowForPointProviderImpl(
                windowsProvider: try di.resolve()
            )
        }
        di.register(type: TouchInjectorFactory.self) { di in
            TouchInjectorFactoryImpl(
                currentAbsoluteTimeProvider: try di.resolve(),
                runLoopSpinnerFactory: try di.resolve()
            )
        }
        di.register(type: CurrentAbsoluteTimeProvider.self) { _ in
            MachCurrentAbsoluteTimeProvider()
        }
        // END OF TODO
    }
}
