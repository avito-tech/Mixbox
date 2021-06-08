#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public protocol IpcStarter: AnyObject {
    // TODO: IpcClient should not be nil
    func start(commandsForAddingRoutes: [IpcMethodHandlerRegistrationTypeErasedClosure])
        throws
        -> (IpcRouter, IpcClient?)
}

#endif
