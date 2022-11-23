#if MIXBOX_ENABLE_FRAMEWORK_IPC && MIXBOX_DISABLE_FRAMEWORK_IPC
#error("Ipc is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC)
// The compilation is disabled
#else

import MixboxFoundation

public final class PerformanceLoggingIpcClient: IpcClient {
    private let ipcClient: IpcClient
    private let performanceLogger: PerformanceLogger
    
    public init(
        ipcClient: IpcClient,
        performanceLogger: PerformanceLogger)
    {
        self.ipcClient = ipcClient
        self.performanceLogger = performanceLogger
    }
    
    public func call<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments,
        completion: @escaping (DataResult<Method.ReturnValue, IpcClientError>) -> ())
    {
        let activity = performanceLogger.start(
            staticName: "ipc_call",
            dynamicName: { "ipc_\(method.name)" }
        )
        
        ipcClient.call(
            method: method,
            arguments: arguments,
            completion: {
                activity.stop()
                completion($0)
            }
        )
    }
}

#endif
