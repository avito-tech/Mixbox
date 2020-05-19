#if DEBUG

import MixboxInAppServices
import MixboxIpc
import TestsIpc

final class CustomIpcMethods {
    private let uiEventHistoryProvider: UiEventHistoryProvider
    private let rootViewControllerManager: RootViewControllerManager
    
    init(
        uiEventHistoryProvider: UiEventHistoryProvider,
        rootViewControllerManager: RootViewControllerManager)
    {
        self.uiEventHistoryProvider = uiEventHistoryProvider
        self.rootViewControllerManager = rootViewControllerManager
    }
    
    func registerIn(_ mixboxInAppServices: MixboxInAppServices) {
        // General
        mixboxInAppServices.register { [rootViewControllerManager] _ in
            SetScreenIpcMethodHandler(
                mixboxInAppServices: mixboxInAppServices,
                rootViewControllerManager: rootViewControllerManager
            )
        }
        
        // For Echo Ipc tests
        mixboxInAppServices.register { _ in EchoIpcMethodHandler<String>() }
        mixboxInAppServices.register { _ in EchoIpcMethodHandler<Int>() }
        mixboxInAppServices.register { _ in EchoIpcMethodHandler<IpcVoid>() }
        mixboxInAppServices.register { _ in EchoIpcMethodHandler<Bool>() }
        mixboxInAppServices.register { _ in EchoIpcMethodHandler<[String]>() }
        mixboxInAppServices.register { _ in EchoIpcMethodHandler<[String: String]>() }
        
        // For Bidirectional Ipc tests
        mixboxInAppServices.register { dependencies in
            BidirectionalIpcPingPongMethodHandler(
                ipcClient: dependencies.synchronousIpcClient
            )
        }
        
        // For Callback tests
        mixboxInAppServices.register { _ in CallbackFromAppIpcMethodHandler<Int>() }
        mixboxInAppServices.register { _ in CallbackToAppIpcMethodHandler<Int, String>() }
        mixboxInAppServices.register { _ in NestedCallbacksToAppIpcMethodHandler() }
        
        // For Launching tests
        mixboxInAppServices.register { _ in ProcessInfoIpcMethodHandler() }
        
        // For Actions tests
        mixboxInAppServices.register { [uiEventHistoryProvider] _ in
            GetUiEventHistoryIpcMethodHandler(
                uiEventHistoryProvider: uiEventHistoryProvider
            )
        }
    }
}

#endif
