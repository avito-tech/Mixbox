#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class WriteableIpcObjectRepositoryOf<T>: WriteableIpcObjectRepository {
    public typealias IpcObjectType = T
    public typealias InsertImpl = (_ object: IpcObjectType, _ ipcObjectId: IpcObjectId) -> InsertedIpcObject
    
    private let insertImpl: InsertImpl
    private var writeableIpcObjectRepository: AnyObject? // For debugging (visible in debugger)
    
    public init(
        insertImpl: @escaping InsertImpl)
    {
        self.insertImpl = insertImpl
    }
    
    public convenience init<R: WriteableIpcObjectRepository>(
        writeableIpcObjectRepository: R)
        where
        R.IpcObjectType == IpcObjectType
    {
        self.init(
            insertImpl: writeableIpcObjectRepository.insert
        )
        
        self.writeableIpcObjectRepository = writeableIpcObjectRepository
    }
    
    public func insert(object: T, ipcObjectId: IpcObjectId) -> InsertedIpcObject {
        return insertImpl(object, ipcObjectId)
    }
}

// Copypasted from `WriteableIpcObjectRepositoryOf`, I have no idea why it was needed in Swift 4.2:
public extension WriteableIpcObjectRepositoryOf where T: IpcObjectIdentifiable {
    func insert(object: IpcObjectType) -> InsertedIpcObject {
        return insert(object: object, ipcObjectId: object.ipcObjectId)
    }
}

#endif
