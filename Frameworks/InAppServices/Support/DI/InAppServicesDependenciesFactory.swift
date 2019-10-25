#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon
import MixboxFoundation

public protocol InAppServicesDependenciesFactory: class {
    var ipcStarter: IpcStarter { get }
    var accessibilityEnhancer: AccessibilityEnhancer { get }
    var assertingSwizzler: AssertingSwizzler { get }
    var keyboardEventInjector: KeyboardEventInjector { get }
    
    func mixboxUrlProtocolBootstrapper(
        ipcRouter: IpcRouter,
        ipcClient: IpcClient)
        -> MixboxUrlProtocolBootstrapper?
}

#endif
