#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxIpc

public final class IpcMethodHandlerRegistrationDependencies {
    public let ipcRouter: IpcRouter
    public let ipcClient: IpcClient? // TODO: Make it not optional after removing SBTUITestTunnel
    public let synchronousIpcClient: SynchronousIpcClient? // TODO: Make it not optional too
    
    public init(
        ipcRouter: IpcRouter,
        ipcClient: IpcClient?,
        synchronousIpcClient: SynchronousIpcClient?)
    {
        self.ipcRouter = ipcRouter
        self.ipcClient = ipcClient
        self.synchronousIpcClient = synchronousIpcClient
    }
}

#endif
