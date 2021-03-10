#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol WriteableIpcObjectRepository: class {
    associatedtype IpcObjectType
    
    // Example of usage:
    //
    // ```
    // repository.insert(object: object, ipcObjectId: object.ipcObjectId) // Because object should be `IpcObjectIdentifiable`
    // ```
    //
    // It is highly recommended to make objects `IpcObjectIdentifiable`. This wil guarantee that the id will be unique
    // for every object and that you only need an instance to object to get its id.
    //
    // Note that you can't use `ObjectIdentifier`, because its object may be deinited and replaced with other object (RAM is reused).
    //
    // Consider using extension with `IpcObjectIdentifiable` if possible. The main issue with that function is that:
    // - It can not be declared inside this protocol, because it will make unavailable passing protocols as generic parameters
    //   to IpcObjectRepositoryImpl. Example of compiler error: `Using 'BridgedUrlProtocolClass & IpcObjectIdentifiable'
    //   as a concrete type conforming to protocol 'IpcObjectIdentifiable' is not supported`
    // - Swift fails to resolve that function in code for unclear reason, so it can not be used in most situations.
    //
    // So, please, use it as in the example above.
    //
    func insert(object: IpcObjectType, ipcObjectId: IpcObjectId) -> InsertedIpcObject
}

extension WriteableIpcObjectRepository where IpcObjectType: IpcObjectIdentifiable {
    public func insert(object: IpcObjectType) -> InsertedIpcObject {
        return insert(object: object, ipcObjectId: object.ipcObjectId)
    }
}

extension WriteableIpcObjectRepository {
    public func toStorable() -> WriteableIpcObjectRepositoryOf<IpcObjectType> {
        return WriteableIpcObjectRepositoryOf(writeableIpcObjectRepository: self)
    }
}

#endif
