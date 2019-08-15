#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

final class HelloIpcMethod: IpcMethod {
    typealias Arguments = IpcVoid
    typealias ReturnValue = String
}

#endif
