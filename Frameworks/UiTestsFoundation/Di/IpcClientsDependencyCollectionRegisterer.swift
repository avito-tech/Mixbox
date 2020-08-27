import MixboxDi
import MixboxFoundation
import MixboxTestsFoundation
import MixboxUiKit
import MixboxIpc
import MixboxIpcCommon

// Note: IPC clients are different for different apps with MixboxInAppServices.
// Note: It is always one app in "gray box" testing.
public final class IpcClientsDependencyCollectionRegisterer: DependencyCollectionRegisterer {
    public init() {
    }
    
    public func register(dependencyRegisterer di: DependencyRegisterer) {
        di.register(type: LazilyInitializedIpcClient.self) { _ in
            LazilyInitializedIpcClient()
        }
        di.register(type: IpcClient.self) { di in
            try di.resolve() as LazilyInitializedIpcClient
        }
        di.register(type: SynchronousIpcClient.self) { di in
            let synchronousIpcClientFactory = try di.resolve() as SynchronousIpcClientFactory
            
            return synchronousIpcClientFactory.synchronousIpcClient(
                ipcClient: try di.resolve()
            )
        }
        di.register(type: KeyboardEventInjector.self) { di in
            IpcKeyboardEventInjector(
                ipcClient: try di.resolve()
            )
        }
        di.register(type: SynchronousKeyboardEventInjector.self) { di in
            SynchronousKeyboardEventInjectorImpl(
                keyboardEventInjector: try di.resolve(),
                runLoopSpinningWaiter: try di.resolve()
            )
        }
        di.register(type: Pasteboard.self) { di in
            IpcPasteboard(
                ipcClient: try di.resolve()
            )
        }
        
        // Page object making helper
        
        di.register(type: SynchronousAlertDisplayer.self) { di in
            IpcAlertDisplayer(
                synchronousIpcClient: try di.resolve()
            )
        }
        di.register(type: SynchronousPageObjectElementGenerationWizardRunner.self) { di in
            IpcPageObjectElementGenerationWizardRunner(
                synchronousIpcClient: try di.resolve()
            )
        }
    }
}
