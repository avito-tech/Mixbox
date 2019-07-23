#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class ReadableIpcObjectRepositoryOf<T>: ReadableIpcObjectRepository {
    public typealias IpcObjectType = T
    public typealias ObjectImpl = (_ id: IpcObjectId) -> IpcObjectType?
    
    private let objectImpl: ObjectImpl
    private var readableIpcObjectRepository: AnyObject? // For debugging (visible in debugger)
    
    public init(objectImpl: @escaping ObjectImpl) {
        self.objectImpl = objectImpl
    }
    
    public convenience init<R: ReadableIpcObjectRepository>(
        readableIpcObjectRepository: R)
        where
        R.IpcObjectType == IpcObjectType
    {
        self.init(
            objectImpl: readableIpcObjectRepository.object
        )
        
        self.readableIpcObjectRepository = readableIpcObjectRepository
    }
    
    public func object(ipcObjectId: IpcObjectId) -> IpcObjectType? {
        return objectImpl(ipcObjectId)
    }
}

#endif
