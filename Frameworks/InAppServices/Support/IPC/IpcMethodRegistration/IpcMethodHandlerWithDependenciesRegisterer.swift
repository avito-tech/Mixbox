#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public protocol IpcMethodHandlerWithDependenciesRegisterer {
    func register<MethodHandler: IpcMethodHandler>(closure: @escaping IpcMethodHandlerRegistrationClosure<MethodHandler>)
}

#endif
