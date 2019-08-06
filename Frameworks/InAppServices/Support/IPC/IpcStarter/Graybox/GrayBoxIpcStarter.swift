#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation
import MixboxIpc

public final class GrayBoxIpcStarter: IpcStarter {
    private let sameProcessIpcClientServer = SameProcessIpcClientServer()
    
    public init() {
    }
    
    public func start(commandsForAddingRoutes: [IpcMethodHandlerRegistrationTypeErasedClosure]) throws -> (IpcRouter, IpcClient?) {
        // TODO: Remove from IpcStarter. It has nothing to do with IPC.
        try setUpAccessibilityForSimulator()
        
        let dependencies = IpcMethodHandlerRegistrationDependencies(
            ipcRouter: sameProcessIpcClientServer,
            ipcClient: sameProcessIpcClientServer
        )
        
        commandsForAddingRoutes.forEach { command in
            command(dependencies)
        }
        
        return (sameProcessIpcClientServer, sameProcessIpcClientServer)
    }
    
    private func setUpAccessibilityForSimulator() throws {
        if let error = AccessibilityOnSimulatorInitializer().setupAccessibilityOrReturnError() {
            throw ErrorString("Couldn't start set up accessibility: \(error)")
        }
    }
}

#endif
