#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public protocol IpcMethodHandlersRegisterer: class {
    func registerIn(ipcRouter: IpcRouter)
}

#endif
