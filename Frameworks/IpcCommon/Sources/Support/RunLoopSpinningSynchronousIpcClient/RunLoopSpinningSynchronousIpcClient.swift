#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

import MixboxIpc
import MixboxFoundation

public final class RunLoopSpinningSynchronousIpcClient: SynchronousIpcClient {
    private let ipcClient: IpcClient
    private let runLoopSpinningWaiter: RunLoopSpinningWaiter
    private let timeout: TimeInterval
    
    public init(
        ipcClient: IpcClient,
        runLoopSpinningWaiter: RunLoopSpinningWaiter,
        timeout: TimeInterval)
    {
        self.ipcClient = ipcClient
        self.runLoopSpinningWaiter = runLoopSpinningWaiter
        self.timeout = timeout
    }
    
    public func call<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments)
        -> DataResult<Method.ReturnValue, Error>
    {
        var result: DataResult<Method.ReturnValue, Error>?
        
        ipcClient.call(method: method, arguments: arguments) { localResult in
            result = localResult
        }
        
        runLoopSpinningWaiter.wait(timeout: timeout, until: { result != nil })
        
        return result ?? .error(ErrorString("noResponse")) // TODO: Better error
    }
}

#endif
