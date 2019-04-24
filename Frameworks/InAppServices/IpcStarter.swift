#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public protocol IpcStarter {
    // TODO: IpcClient should not be nil
    func start(commandsForAddingRoutes: [(IpcRouter) -> ()]) -> (IpcRouter, IpcClient?)
}

#endif
