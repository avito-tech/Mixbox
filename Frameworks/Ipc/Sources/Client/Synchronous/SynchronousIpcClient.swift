#if MIXBOX_ENABLE_FRAMEWORK_IPC && MIXBOX_DISABLE_FRAMEWORK_IPC
#error("Ipc is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC)
// The compilation is disabled
#else

import MixboxFoundation

public protocol SynchronousIpcClient {
    func call<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments)
        -> DataResult<Method.ReturnValue, Error>
}

extension SynchronousIpcClient {
    // Synchronous version for methods without arguments
    public func call<Method: IpcMethod>(
        method: Method)
        -> DataResult<Method.ReturnValue, Error>
        where Method.Arguments == IpcVoid
    {
        return call(method: method, arguments: IpcVoid())
    }
}

#endif
