#if DEBUG

import MixboxInAppServices
import MixboxIpc
import TestsIpc

final class CustomIpcMethods {
    private let rootViewControllerManager: RootViewControllerManager
    
    init(
        rootViewControllerManager: RootViewControllerManager)
    {
        self.rootViewControllerManager = rootViewControllerManager
    }
    
    func registerIn(_ registerer: IpcMethodHandlerWithDependenciesRegisterer) {
        // General
        registerer.register { [rootViewControllerManager] _ in
            SetScreenIpcMethodHandler(
                ipcMethodHandlerWithDependenciesRegisterer: registerer,
                rootViewControllerManager: rootViewControllerManager
            )
        }
        
        // For Echo Ipc tests
        registerer.register { _ in EchoIpcMethodHandler<String>() }
        registerer.register { _ in EchoIpcMethodHandler<Int>() }
        registerer.register { _ in EchoIpcMethodHandler<IpcVoid>() }
        registerer.register { _ in EchoIpcMethodHandler<Bool>() }
        registerer.register { _ in EchoIpcMethodHandler<[String]>() }
        registerer.register { _ in EchoIpcMethodHandler<[String: String]>() }
        
        // For Bidirectional Ipc tests
        registerer.register { dependencies in
            BidirectionalIpcPingPongMethodHandler(
                ipcClient: dependencies.synchronousIpcClient
            )
        }
        
        // For Callback tests
        registerer.register { _ in CallbackFromAppIpcMethodHandler<Int>() }
        registerer.register { _ in CallbackToAppIpcMethodHandler<Int, String>() }
        registerer.register { _ in NestedCallbacksToAppIpcMethodHandler() }
        
        // For Launching tests
        registerer.register { _ in ProcessInfoIpcMethodHandler() }
    }
}

#endif
