#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

import MixboxFoundation

public protocol ReadableIpcObjectRepository: AnyObject {
    associatedtype IpcObjectType
    
    func object(ipcObjectId: IpcObjectId) -> IpcObjectType?
}

extension ReadableIpcObjectRepository {
    public func toStorable() -> ReadableIpcObjectRepositoryOf<IpcObjectType> {
        return ReadableIpcObjectRepositoryOf(readableIpcObjectRepository: self)
    }
    
    public func toStorable<U>(
        mapping: @escaping (IpcObjectType) -> U)
        -> ReadableIpcObjectRepositoryOf<U>
    {
        return ReadableIpcObjectRepositoryOf(
            objectImpl: { (ipcObjectId) -> U? in
                self.object(ipcObjectId: ipcObjectId).map(mapping)
            },
            readableIpcObjectRepository: self
        )
    }
    
    public func objectOrThrow(ipcObjectId: IpcObjectId) throws -> IpcObjectType {
        guard let object = self.object(ipcObjectId: ipcObjectId) else {
            throw ErrorString(
                """
                Failed to get object of type \(IpcObjectType.self). \
                Object was not added to or it was removed from object repository \(self).
                """
            )
        }
        
        return object
    }
}

#endif
