#if MIXBOX_ENABLE_IN_APP_SERVICES

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
