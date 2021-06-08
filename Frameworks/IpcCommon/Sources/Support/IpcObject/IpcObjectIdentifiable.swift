#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol IpcObjectIdentifiable: AnyObject {
    var ipcObjectId: IpcObjectId { get }
}

#endif
