#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxDi

public protocol InAppServicesStarter {
    func start(
        dependencyResolver: DependencyResolver,
        commandsForAddingRoutes: [IpcMethodHandlerRegistrationTypeErasedClosure])
        throws
        -> StartedInAppServices
}

#endif
