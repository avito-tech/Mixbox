import MixboxDi
import MixboxUiTestsFoundation

// Dependencies that depend on specific application.
//
// It is safe to include those in the context of a single application.
//
// It can be a global DI if you are using a single application. Or it can be a local DI for code
// that works with with a single application (for example, in internal implementation of Mixbox
// it is used in a local DI for an interaction with specific application).
//
// It is not safe to include it in the context of multiple applications. Note that it's likely
// that if you do this by mistake, DI will fail, becauuse this registerer doesn't register
// `ApplicationProvider` by default. But in case it is declared somewhere else there might be nontrivial
// bugs, for example, you want to interact with app `A`, but some dependency will work with some global app `B`.
//
// In short, do not use singleton dependencies for apps in DI if you use multiple apps.
//
public final class BlackBoxApplicationDependentDependencyCollectionRegisterer: BaseBlackBoxDependencyCollectionRegisterer {
    override public init() {
    }
    
    override public func register(dependencyRegisterer di: DependencyRegisterer) {
        super.register(dependencyRegisterer: di)
        
        di.register(type: ApplicationScreenshotTaker.self) { di in
            XcuiApplicationScreenshotTaker(
                applicationProvider: try di.resolve()
            )
        }
        di.register(type: ElementFinder.self) { di in
            UiKitHierarchyElementFinder(
                ipcClient: try di.resolve(),
                testFailureRecorder: try di.resolve(),
                stepLogger: try di.resolve(),
                applicationScreenshotTaker: try di.resolve(),
                performanceLogger: try di.resolve(),
                dateProvider: try di.resolve()
            )
        }
        di.register(type: EventGenerator.self) { di in
            XcuiEventGenerator(
                applicationProvider: try di.resolve()
            )
        }
        di.register(type: ApplicationQuiescenceWaiter.self) { di in
            XcuiApplicationQuiescenceWaiter(
                applicationProvider: try di.resolve()
            )
        }
        di.register(type: PageObjectDependenciesFactory.self) { di in
            XcuiPageObjectDependenciesFactory(
                dependencyResolver: WeakDependencyResolver(dependencyResolver: di),
                dependencyInjectionFactory: try di.resolve(),
                ipcClient: try di.resolve(),
                elementFinder: try di.resolve(),
                applicationProvider: try di.resolve()
            )
        }
        di.register(type: ApplicationFrameProvider.self) { di in
            XcuiApplicationFrameProvider(
                applicationProvider: try di.resolve()
            )
        }
        di.register(type: ApplicationCoordinatesProvider.self) { di in
            ApplicationCoordinatesProviderImpl(
                applicationProvider: try di.resolve(),
                applicationFrameProvider: try di.resolve()
            )
        }
    }
}
