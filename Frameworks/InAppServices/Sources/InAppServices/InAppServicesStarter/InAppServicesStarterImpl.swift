#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxDi

public final class InAppServicesStarterImpl: InAppServicesStarter {
    public init() {
    }
    
    public func start(
        dependencyResolver: DependencyResolver,
        commandsForAddingRoutes: [IpcMethodHandlerRegistrationTypeErasedClosure])
        throws
        -> StartedInAppServices
    {
        let accessibilityForTestAutomationInitializer: AccessibilityForTestAutomationInitializer = try dependencyResolver.resolve()
        try accessibilityForTestAutomationInitializer.initializeAccessibility()
        
        let simulatorStateInitializer: SimulatorStateInitializer = try dependencyResolver.resolve()
        try simulatorStateInitializer.initializeSimulatorState()
        
        let ipcStarterProvider: IpcStarterProvider = try dependencyResolver.resolve()
        let ipcStarter = try ipcStarterProvider.ipcStarter()
        
        let startedIpc = try ipcStarter.start(
            commandsForAddingRoutes: commandsForAddingRoutes
        )
        
        try (dependencyResolver.resolve() as AccessibilityEnhancer).enhanceAccessibility()
        
        try (dependencyResolver.resolve() as ScrollViewIdlingResourceSwizzler).swizzle()
        try (dependencyResolver.resolve() as UiAnimationIdlingResourceSwizzler).swizzle()
        try (dependencyResolver.resolve() as ViewControllerIdlingResourceSwizzler).swizzle()
        try (dependencyResolver.resolve() as CoreAnimationIdlingResourceSwizzler).swizzle()
        
        let mixboxUrlProtocolBootstrapper: MixboxUrlProtocolBootstrapper? = try startedIpc.ipcClient.flatMap { ipcClient in
            let mixboxUrlProtocolBootstrapperFactory: MixboxUrlProtocolBootstrapperFactory = try dependencyResolver.resolve()
            
            return try mixboxUrlProtocolBootstrapperFactory.mixboxUrlProtocolBootstrapper(
                ipcRouter: startedIpc.ipcRouter,
                ipcClient: ipcClient
            )
        }
        
        mixboxUrlProtocolBootstrapper?.bootstrapNetworkMocking()
        
        return StartedInAppServices(
            startedIpc: startedIpc
        )
    }
}

#endif
