#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public typealias IpcMethodHandlerRegistrationClosure<MethodHandler: IpcMethodHandler>
    = (IpcMethodHandlerRegistrationDependencies) -> MethodHandler

#endif
