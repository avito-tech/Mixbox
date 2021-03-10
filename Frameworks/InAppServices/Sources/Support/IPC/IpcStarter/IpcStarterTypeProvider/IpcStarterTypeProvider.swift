#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon

public protocol IpcStarterTypeProvider {
    func ipcStarterType() throws -> IpcStarterType
}

#endif
