#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public protocol IpcStarter: class {
    // TODO: IpcClient should not be nil
    func start(commandsForAddingRoutes: [(IpcRouter) -> ()])
        throws
        -> (IpcRouter, IpcClient?)
}

#endif
