#if MIXBOX_ENABLE_FRAMEWORK_BUILTIN_IPC && MIXBOX_DISABLE_FRAMEWORK_BUILTIN_IPC
#error("BuiltinIpc is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_BUILTIN_IPC || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_BUILTIN_IPC)
// The compilation is disabled
#else

import MixboxIpc

public class CallIpcCallbackIpcMethod: IpcMethod {
    public typealias Arguments = CallIpcCallbackIpcMethodArguments
    public typealias ReturnValue = String?
}

public final class CallIpcCallbackIpcMethodArguments: Codable {
    public let callbackId: String
    public let callbackArguments: String
    
    public init(
        callbackId: String,
        callbackArguments: String)
    {
        self.callbackId = callbackId
        self.callbackArguments = callbackArguments
    }
}

#endif
