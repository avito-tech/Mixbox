#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

public final class IpcObjectRepositoryImpl<T>: IpcObjectRepository {
    public typealias IpcObjectType = T
    
    private var objectByIpcObjectId = [IpcObjectId: T]()
    
    public init() {
    }
    
    public func object(ipcObjectId: IpcObjectId) -> IpcObjectType? {
        return objectByIpcObjectId[ipcObjectId]
    }
    
    public func insert(object: IpcObjectType, ipcObjectId: IpcObjectId) -> InsertedIpcObject {
        objectByIpcObjectId[ipcObjectId] = object
        
        return ClosureInsertedIpcObject(
            removeImpl: {
                self.objectByIpcObjectId[ipcObjectId] = nil
            }
        )
    }
}

#endif
