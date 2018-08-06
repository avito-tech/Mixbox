import MixboxIpc

public final class SbtuiIpcRouter: IpcRouter {
    private var registeredCommands = [String: SbtuiCustomCommand]()
    
    public init() {
    }
    
    public func register<MethodHandler: IpcMethodHandler>(methodHandler: MethodHandler) {
        let command = SbtuiCustomCommand(ipcMethodHandler: methodHandler)
        registeredCommands[methodHandler.method.name] = command
        command.register()
    }
}
