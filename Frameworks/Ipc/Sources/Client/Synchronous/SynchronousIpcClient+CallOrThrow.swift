#if MIXBOX_ENABLE_FRAMEWORK_IPC && MIXBOX_DISABLE_FRAMEWORK_IPC
#error("Ipc is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC)
// The compilation is disabled
#else

import MixboxFoundation

extension SynchronousIpcClient {
    // Synchronous throwing version
    public func callOrThrow<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments)
        throws
        -> Method.ReturnValue
    {
        let result = call(
            method: method,
            arguments: arguments
        )
        
        switch result {
        case .data(let data):
            return data
        case .error(let error):
            throw ErrorString(
                "Failed calling method \(method) with arguments \(arguments) by IpcClient: \(error)"
            )
        }
    }
    
    // Synchronous throwing version for methods without Arguments
    public func callOrThrow<Method: IpcMethod>(
        method: Method)
        throws
        -> Method.ReturnValue
        where Method.Arguments == IpcVoid
    {
        return try callOrThrow(
            method: method,
            arguments: IpcVoid()
        )
    }
    
    // Synchronous throwing version for methods without ReturnValue
    public func callOrThrow<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments)
        throws
        where Method.ReturnValue == IpcVoid
    {
        let _: IpcVoid = try callOrThrow(
            method: method,
            arguments: arguments
        )
    }
    
    // Synchronous throwing version for methods without Arguments & ReturnValue
    public func callOrThrow<Method: IpcMethod>(
        method: Method)
        throws
        where
        Method.ReturnValue == IpcVoid,
        Method.Arguments == IpcVoid
    {
        let _: IpcVoid = try callOrThrow(
            method: method,
            arguments: IpcVoid()
        )
    }
}

#endif
