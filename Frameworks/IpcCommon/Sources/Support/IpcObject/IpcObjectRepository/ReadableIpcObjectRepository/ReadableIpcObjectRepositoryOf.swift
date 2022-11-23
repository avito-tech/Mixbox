#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

public final class ReadableIpcObjectRepositoryOf<T>:
    ReadableIpcObjectRepository,
    CustomDebugStringConvertible
{
    public typealias IpcObjectType = T
    public typealias ObjectImpl = (_ id: IpcObjectId) -> IpcObjectType?
    
    private let objectImpl: ObjectImpl
    private var readableIpcObjectRepository: AnyObject? // For debugging (visible in debugger)
    
    public init(objectImpl: @escaping ObjectImpl) {
        self.objectImpl = objectImpl
    }
    
    internal convenience init<R: ReadableIpcObjectRepository>(
        objectImpl: @escaping ObjectImpl,
        readableIpcObjectRepository: R)
    {
        self.init(
            objectImpl: objectImpl
        )
        
        self.readableIpcObjectRepository = readableIpcObjectRepository
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
    
    // MARK: - ReadableIpcObjectRepository
    
    public func object(ipcObjectId: IpcObjectId) -> IpcObjectType? {
        return objectImpl(ipcObjectId)
    }
    
    // MARK: - CustomDebugStringConvertible
    
    public var debugDescription: String {
        if let readableIpcObjectRepository = readableIpcObjectRepository {
            return "<ReadableIpcObjectRepositoryOf<\(T.self)>> nesting readableIpcObjectRepository: \(readableIpcObjectRepository)"
        } else {
            return "<ReadableIpcObjectRepositoryOf<\(T.self)>>"
        }
    }
}

#endif
