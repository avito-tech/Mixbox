#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol IpcObjectIdentifiable: class {
    var ipcObjectId: IpcObjectId { get }
}

#endif
