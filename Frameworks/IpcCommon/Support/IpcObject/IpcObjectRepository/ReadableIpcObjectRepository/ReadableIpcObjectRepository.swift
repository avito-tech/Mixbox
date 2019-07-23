#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

public protocol ReadableIpcObjectRepository: class {
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
            }
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
