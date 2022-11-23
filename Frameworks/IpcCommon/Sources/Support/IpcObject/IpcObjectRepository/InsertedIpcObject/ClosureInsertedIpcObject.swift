#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

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
