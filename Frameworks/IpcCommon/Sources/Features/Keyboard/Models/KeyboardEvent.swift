#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

public class KeyboardEvent: Codable {
    public let usagePage: UInt16
    public let usage: UInt16
    public let down: Bool
    
    public init(
        usagePage: UInt16,
        usage: UInt16,
        down: Bool)
    {
        self.usagePage = usagePage
        self.usage = usage
        self.down = down
    }
}

#endif
