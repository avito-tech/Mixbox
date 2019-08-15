#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol IpcCallbackStorageHolder: class {
    var ipcCallbackStorage: IpcCallbackStorage { get }
}

#endif
