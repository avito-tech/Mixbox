#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public protocol InAppServicesDependenciesFactory: class {
    var ipcStarter: IpcStarter { get }
    var accessibilityEnhancer: AccessibilityEnhancer { get }
    
    func mixboxUrlProtocolBootstrapper(
        ipcRouter: IpcRouter,
        ipcClient: IpcClient)
        -> MixboxUrlProtocolBootstrapper?
}

#endif
