#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public protocol MixboxUrlProtocolBootstrapperFactory {
    func mixboxUrlProtocolBootstrapper(
        ipcRouter: IpcRouter,
        ipcClient: IpcClient)
        throws
        -> MixboxUrlProtocolBootstrapper?
}

#endif
