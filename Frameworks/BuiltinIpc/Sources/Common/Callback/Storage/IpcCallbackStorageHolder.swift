#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol IpcCallbackStorageHolder: AnyObject {
    var ipcCallbackStorage: IpcCallbackStorage { get }
}

#endif
