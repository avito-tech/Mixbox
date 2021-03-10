#if MIXBOX_ENABLE_IN_APP_SERVICES

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
