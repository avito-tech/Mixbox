#if MIXBOX_ENABLE_FRAMEWORK_IPC_SBTUI_HOST && MIXBOX_DISABLE_FRAMEWORK_IPC_SBTUI_HOST
#error("IpcSbtuiHost is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_SBTUI_HOST || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_SBTUI_HOST)
// The compilation is disabled
#else

import MixboxIpc

public final class SbtuiIpcRouter: IpcRouter {
     // TODO: Is it unused? Check if it is used as storage.
    private var registeredCommands = [String: SbtuiCustomCommand]()
    
    // Prevents assertion failure in SBTUI. However, it might be useful, so it can be both false/true.
    private let reregisterMethodHandlersAutomatically: Bool
    
    public init(reregisterMethodHandlersAutomatically: Bool) {
        self.reregisterMethodHandlersAutomatically = reregisterMethodHandlersAutomatically
    }
    
    public func register<MethodHandler: IpcMethodHandler>(methodHandler: MethodHandler) {
        let command = SbtuiCustomCommand(ipcMethodHandler: methodHandler)
        
        registeredCommands[methodHandler.method.name] = command
        
        if reregisterMethodHandlersAutomatically {
            command.unregister()
        }
        
        command.register()
    }
}

#endif
