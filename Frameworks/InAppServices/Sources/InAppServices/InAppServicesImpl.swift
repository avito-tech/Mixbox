#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxIpc
import MixboxIpcCommon
import MixboxFoundation
import MixboxDi
import MixboxBuiltinDi

public final class InAppServicesImpl: InAppServices {
    // Dependencies
    private let dependencyRegisterer: DependencyRegisterer
    private let dependencyResolver: DependencyResolver
    private let dependencyCollectionRegisterer: DependencyCollectionRegisterer
    private let defaultUiEventObservableHolder = UiEventObservableHolder()
    
    // State
    private var startedInAppServices: StartedInAppServices?
    private var commandsForAddingRoutes: [IpcMethodHandlerRegistrationTypeErasedClosure] = []
    
    // MARK: - Init
    
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
                try Self.registerDefaultMethods(
                    router: dependencies.ipcRouter,
                    dependencyResolver: dependencyResolver
                )
            }
        ]
    }
    
    // MARK: - IpcMethodHandlerWithDependenciesRegisterer
    
    public func register<MethodHandler: IpcMethodHandler>(closure: @escaping IpcMethodHandlerRegistrationClosure<MethodHandler>) {
        if let startedInAppServices = startedInAppServices {
            tryOrReportFailure {
                let synchronousIpcClientFactory: SynchronousIpcClientFactory = try dependencyResolver.resolve()
                
                let dependencies = IpcMethodHandlerRegistrationDependencies(
                    ipcRouter: startedInAppServices.startedIpc.ipcRouter,
                    ipcClient: startedInAppServices.startedIpc.ipcClient,
                    synchronousIpcClient: startedInAppServices.startedIpc.ipcClient.map {
                        synchronousIpcClientFactory.synchronousIpcClient(ipcClient: $0)
                    }
                )
                
                startedInAppServices.startedIpc.ipcRouter.register(
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
    
    // MARK: - UiEventObservableSetter
    
    public func set(uiEventObservable: UiEventObservable) {
        do {
            // To allow user to redefine `UiEventObservableSetter`.
            let uiEventObservableSetter: UiEventObservableSetter = try dependencyResolver.resolve()
            uiEventObservableSetter.set(uiEventObservable: uiEventObservable)
        } catch {
            // To allow user to not define `UiEventObservableSetter` and this doesn't use
            // DependencyResolver, because it would be better to not use throwing functions in this facade.
            
            defaultUiEventObservableHolder.set(uiEventObservable: uiEventObservable)
        }
    }
    
    // MARK: - InAppServices
    
    public func start() -> StartedInAppServices {
        assert(startedInAppServices == nil, "InAppServices are already started")
        
        dependencyCollectionRegisterer.register(
            dependencyRegisterer: dependencyRegisterer
        )
        
        dependencyRegisterer.registerMultiple { [defaultUiEventObservableHolder] _ in defaultUiEventObservableHolder }
            .reregister { $0 as UiEventObservableProvider }
            .reregister { $0 as UiEventObservableSetter }
        
        return tryOrFail {
            let inAppServicesStarter: InAppServicesStarter = try dependencyResolver.resolve()
            
            let startedInAppServices = try inAppServicesStarter.start(
                dependencyResolver: dependencyResolver,
                commandsForAddingRoutes: commandsForAddingRoutes
            )
            
            self.startedInAppServices = startedInAppServices
            
            commandsForAddingRoutes = []
            
            return startedInAppServices
        }
    }
    
    // MARK: - Private

    // TODO: Split, move to a separate class
    // swiftlint:disable:next function_body_length
    private static func registerDefaultMethods(
        router: IpcRouter,
        dependencyResolver: DependencyResolver)
        throws
    {
        router.register(methodHandler: try ScrollingHintIpcMethodHandler(
            scrollingHintsForViewProvider: dependencyResolver.resolve(),
            accessibilityUniqueObjectMap: dependencyResolver.resolve()
        ))
        router.register(methodHandler: try CheckVisibilityIpcMethodHandler(
            viewVisibilityChecker: dependencyResolver.resolve(),
            nonViewVisibilityChecker: dependencyResolver.resolve(),
            iosVersionProvider: dependencyResolver.resolve(),
            accessibilityUniqueObjectMap: dependencyResolver.resolve()
        ))
        router.register(
            methodHandler: ViewHierarchyIpcMethodHandler(
                viewHierarchyProvider: try dependencyResolver.resolve()
            )
        )
        
        router.register(methodHandler: OpenUrlIpcMethodHandler())
        
        router.register(methodHandler: try SimulateLocationIpcMethodHandler(
            locationSimulationManager: dependencyResolver.resolve()
        ))
        router.register(methodHandler: try StopLocationSimulationIpcMethodHandler(
            locationSimulationManager: dependencyResolver.resolve()
        ))
        
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
        
        router.register(
            methodHandler: UiEventObserverFeatureToggleIpcMethodHandler(
                method: SetTouchDrawerEnabledIpcMethod(),
                uiEventObserverFeatureToggleValueSetter: UiEventObserverFeatureToggler(
                    uiEventObservableProvider: try dependencyResolver.resolve(),
                    uiEventObserver: TouchDrawer()
                )
            )
        )
        
        let historyTrackerToggler = UiEventObserverFeatureToggler(
            uiEventObservableProvider: try dependencyResolver.resolve(),
            uiEventObserver: try dependencyResolver.resolve() as UiEventHistoryTracker
        )
        
        router.register(
            methodHandler: UiEventObserverFeatureToggleIpcMethodHandler(
                method: SetUiEventHistoryTrackerEnabledIpcMethod(),
                uiEventObserverFeatureToggleValueSetter: historyTrackerToggler
            )
        )
        router.register(
            methodHandler: GetUiEventHistoryIpcMethodHandler(
                uiEventHistoryProvider: try dependencyResolver.resolve(),
                uiEventObserverFeatureToggleValueGetter: historyTrackerToggler
            )
        )
        router.register(
            methodHandler: DisplayAlertIpcMethodHandler(
                alertDisplayer: InAppAlertDisplayer(
                    applicationWindowsProvider: try dependencyResolver.resolve()
                )
            )
        )
        router.register(
            methodHandler: RunPageObjectElementGenerationWizardIpcMethodHandler(
                pageObjectElementGenerationWizardRunner: try dependencyResolver.resolve()
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
