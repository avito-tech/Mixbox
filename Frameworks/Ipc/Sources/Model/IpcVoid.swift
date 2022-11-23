#if MIXBOX_ENABLE_FRAMEWORK_IPC && MIXBOX_DISABLE_FRAMEWORK_IPC
#error("Ipc is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC)
// The compilation is disabled
#else

// Codable Void, for using in generics. Swift's builtin Void  is not Codable.
//
// Example:
// typealias Arguments = IpcVoid
public final class IpcVoid: Codable, Equatable {
    public init() {
    }
    
    public static func ==(_: IpcVoid, _: IpcVoid) -> Bool {
        return true
    }
}

#endif
