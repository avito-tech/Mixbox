#if MIXBOX_ENABLE_IN_APP_SERVICES

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
