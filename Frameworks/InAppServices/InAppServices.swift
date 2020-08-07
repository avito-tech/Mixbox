#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon
import MixboxFoundation
import MixboxDi
import MixboxBuiltinDi

// Facade for starting everything for tests, on the side of the app.
public final class InAppServices: IpcMethodHandlerWithDependenciesRegisterer {
    // Dependencies
    private let dependencyRegisterer: DependencyRegisterer
    private let dependencyResolver: DependencyResolver
    private let dependencyCollectionRegisterer: DependencyCollectionRegisterer
    
    // State
    private var router: IpcRouter?
    private var client: IpcClient?
    private var commandsForAddingRoutes: [IpcMethodHandlerRegistrationTypeErasedClosure] = []
    
    public convenience init(
        dependencyInjection: DependencyInjection,
        dependencyCollectionRegisterer: DependencyCollectionRegisterer)
    {
        self.init(
            dependencyRegisterer: dependencyInjection,
            dependencyResolver: dependencyInjection,
            dependencyCollectionRegisterer: dependencyCollectionRegisterer
        )
    }
    
    public init(
        dependencyRegisterer: DependencyRegisterer,
        dependencyResolver: DependencyResolver,
        dependencyCollectionRegisterer: DependencyCollectionRegisterer)
    {
        self.dependencyRegisterer = dependencyRegisterer
        self.dependencyResolver = dependencyResolver
        self.dependencyCollectionRegisterer = dependencyCollectionRegisterer
        
        self.commandsForAddingRoutes = [
            { [dependencyResolver] dependencies in
                try InAppServices.registerDefaultMethods(
                    router: dependencies.ipcRouter,
                    dependencyResolver: dependencyResolver
                )
            }
        ]
    }
    
    public func register<MethodHandler: IpcMethodHandler>(closure: @escaping IpcMethodHandlerRegistrationClosure<MethodHandler>) {
        if let router = router {
            tryOrReportFailure {
                let synchronousIpcClientFactory: SynchronousIpcClientFactory = try dependencyResolver.resolve()
                
                let dependencies = IpcMethodHandlerRegistrationDependencies(
                    ipcRouter: router,
                    ipcClient: client,
                    synchronousIpcClient: client.map {
                        synchronousIpcClientFactory.synchronousIpcClient(ipcClient: $0)
                    }
                )
                
                router.register(
                    methodHandler: closure(dependencies)
                )
            }
        } else {
            commandsForAddingRoutes.append({ dependencies in
                dependencies.ipcRouter.register(
                    methodHandler: closure(dependencies)
                )
            })
        }
    }
    
    public func start() -> StartedInAppServices {
        assert(self.router == nil, "InAppServices are already started")
        
        dependencyCollectionRegisterer.register(
            dependencyRegisterer: dependencyRegisterer
        )
        
        return tryOrFail {
            let ipcStarterProvider: IpcStarterProvider = try dependencyResolver.resolve()
            let ipcStarter = try ipcStarterProvider.ipcStarter()
            
            let (router, client) = try ipcStarter.start(
                commandsForAddingRoutes: commandsForAddingRoutes
            )
            
            self.router = router
            self.client = client
            
            try (dependencyResolver.resolve() as AccessibilityEnhancer).enhanceAccessibility()
            
            try (dependencyResolver.resolve() as ScrollViewIdlingResourceSwizzler).swizzle()
            try (dependencyResolver.resolve() as UiAnimationIdlingResourceSwizzler).swizzle()
            try (dependencyResolver.resolve() as ViewControllerIdlingResourceSwizzler).swizzle()
            try (dependencyResolver.resolve() as CoreAnimationIdlingResourceSwizzler).swizzle()
            
            let mixboxUrlProtocolBootstrapper: MixboxUrlProtocolBootstrapper? = try client.flatMap { client in
                let mixboxUrlProtocolBootstrapperFactory: MixboxUrlProtocolBootstrapperFactory = try dependencyResolver.resolve()
                
                return try mixboxUrlProtocolBootstrapperFactory.mixboxUrlProtocolBootstrapper(
                    ipcRouter: router,
                    ipcClient: client
                )
            }
            
            mixboxUrlProtocolBootstrapper?.bootstrapNetworkMocking()
            
            commandsForAddingRoutes = []
            
            return StartedInAppServices(
                router: router,
                client: client
            )
        }
    }

    private static func registerDefaultMethods(
        router: IpcRouter,
        dependencyResolver: DependencyResolver)
        throws
    {
        router.register(methodHandler: ScrollingHintIpcMethodHandler())
        router.register(methodHandler: CheckVisibilityIpcMethodHandler(
            viewVisibilityChecker: try dependencyResolver.resolve()
        ))
        router.register(
            methodHandler: ViewHierarchyIpcMethodHandler(
                viewHierarchyProvider: ViewHierarchyProviderImpl(
                    applicationWindowsProvider: UiApplicationWindowsProvider(
                        uiApplication: UIApplication.shared,
                        iosVersionProvider: try dependencyResolver.resolve()
                    ),
                    floatValuesForSr5346Patcher: FloatValuesForSr5346PatcherImpl(
                        iosVersionProvider: try dependencyResolver.resolve()
                    )
                )
            )
        )
        
        router.register(methodHandler: OpenUrlIpcMethodHandler())
        
        router.register(methodHandler: PushNotificationIpcMethodHandler())
        
        router.register(methodHandler: SimulateLocationIpcMethodHandler())
        router.register(methodHandler: StopLocationSimulationIpcMethodHandler())
        
        router.register(
            methodHandler: InjectKeyboardEventsIpcMethodHandler(
                keyboardEventInjector: try dependencyResolver.resolve()
            )
        )
        
        router.register(methodHandler: GetPasteboardStringIpcMethodHandler())
        router.register(methodHandler: SetPasteboardStringIpcMethodHandler())
        
        router.register(methodHandler: GetUiScreenMainBoundsIpcMethodHandler())
        router.register(methodHandler: GetUiScreenMainScaleIpcMethodHandler())
        
        router.register(
            methodHandler: GetRecordedAssertionFailuresIpcMethodHandler(
                recordedAssertionFailuresProvider: try dependencyResolver.resolve()
            )
        )
    }
    
    private func tryOrReportFailure(body: () throws -> ()) {
        do {
            return try body()
        } catch let bodyError {
            do {
                let assertionFailureRecorder: AssertionFailureRecorder = try dependencyResolver.resolve()
                
                assertionFailureRecorder.recordAssertionFailure(message: "\(bodyError)")
            } catch {
                preconditionFailure("\(bodyError)")
            }
        }
    }
    
    private func tryOrFail<T>(body: () throws -> T) -> T {
        do {
            return try body()
        } catch let bodyError {
            preconditionFailure("\(bodyError)")
        }
    }
}

#endif
