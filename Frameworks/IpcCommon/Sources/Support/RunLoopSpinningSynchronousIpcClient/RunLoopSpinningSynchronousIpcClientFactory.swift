#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

import MixboxIpc
import MixboxFoundation
import Foundation

public final class RunLoopSpinningSynchronousIpcClientFactory: SynchronousIpcClientFactory {
    private let runLoopSpinningWaiter: RunLoopSpinningWaiter
    private let timeout: TimeInterval
    
    public init(
        runLoopSpinningWaiter: RunLoopSpinningWaiter,
        timeout: TimeInterval)
    {
        self.runLoopSpinningWaiter = runLoopSpinningWaiter
        self.timeout = timeout
    }
    
    public func synchronousIpcClient(ipcClient: IpcClient) -> SynchronousIpcClient {
        return RunLoopSpinningSynchronousIpcClient(
            ipcClient: ipcClient,
            runLoopSpinningWaiter: runLoopSpinningWaiter,
            timeout: timeout
        )
    }
}

#endif
