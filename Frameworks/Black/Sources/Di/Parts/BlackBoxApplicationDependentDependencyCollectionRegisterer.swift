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
            try IpcUiKitHierarchyElementFinder(
                ipcClient: di.resolve(),
                performanceLogger: di.resolve(),
                resolvedElementQueryLogger: di.resolve()
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
            // WORKAROUND!
            //
            // `XcuiPageObjectDependenciesFactory` creates its own local di and uses `CompoundDependencyResolver`,
            // which consists of 2 resolvers. One is `parentDi` here, one is temporary for interactions (taps, checks, etc).
            // `XcuiPageObjectDependenciesFactory`. Both are instances of `BuiltinDependencyInjection` and both
            // store cached signleton dependencies.
            //
            // `IpcClientsDependencyCollectionRegisterer` is used in `XcuiPageObjectDependenciesFactory`
            // because in case of multiple applications with IPC we need multiple `IpcClient`'s and multiple entities that use
            // those separate `IpcClient`'s.
            //
            // The problem is that `IpcClientsDependencyCollectionRegisterer` is registered in both DI's.
            // When `IpcClient` is resolved from `parentDi`, it's one instance, when resolved from local DI, it's another instance.
            // This is because resolvers have separate Dictionary of cached dependencies (with `.singleton` scope).
            //
            // Both are instances of `LazilyInitializedIpcClient` and only one receives its `IpcClient` instance after IPC
            // is initialized between the app and test target.
            //
            // So, one of them don't work.
            //
            // Workaround: forcibly register same instance of `IpcClient` from parent di in local di.
            //
            // Possible better solutions:
            //
            // 1. Extend the DI interfaces, implement cloning, because what we need for temporary DI is a clone of DI with temporary dependencies.
            //
            //    Pros: will solve the issue, it's what we actually need.
            //
            //    Cons: this will require us to extend the interfaces with cloning functionality, but simpler interfaces are preferred.
            //
            // 2. Extend the DI interfaces, add the ability to check which dependencies are registered. Use this abiluty to not
            //    register IpcClient in the local DI, or other entities with same problem.
            //
            //    Pros: will solve the issue, can be used for reflection, what is registered and when, adds the ability for users of Mixbox
            //    to fine-tune the DI, for example, they may want to register an entity only if it wasn't registered (currently we can only
            //    override dependencies).
            //
            //    Cons: same as before
            //
            // 3. Extend the DI interfaces, and support sharing of dependencies. So, both resolvers will have references to same storage.
            //    Note, that it we need to not modify the original DI, so the cached dependencies should be only for reading, not writing.
            //
            //    Pros: will solve the issue
            //
            //    Cons: same as before, seems to be a worse solution than cloning
            //
            // NOTE: Currently the case with multiple apps with IPC is not implemened neither in Demo, nor in Tests,
            // but it's important, because Mixbox supports it and its clients use it.
            //
            XcuiPageObjectDependenciesFactory(
                dependencyResolver: WeakDependencyResolver(dependencyResolver: di),
                dependencyInjectionFactory: try di.resolve(),
                ipcClient: { _ in try di.resolve() },
                elementFinder: { _ in try di.resolve() },
                applicationProvider: { _ in try di.resolve() }
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
