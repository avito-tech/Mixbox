#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxFoundation

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
