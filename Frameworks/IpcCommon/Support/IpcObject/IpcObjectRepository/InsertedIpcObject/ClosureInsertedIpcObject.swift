#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class ClosureInsertedIpcObject: InsertedIpcObject {
    public typealias RemoveImpl = () -> ()
    
    private let removeImpl: RemoveImpl
    
    public init(
        removeImpl: @escaping RemoveImpl)
    {
        self.removeImpl = removeImpl
    }
    
    public func remove() {
        removeImpl()
    }
}

#endif
