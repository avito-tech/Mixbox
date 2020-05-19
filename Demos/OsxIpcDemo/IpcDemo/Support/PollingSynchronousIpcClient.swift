import MixboxFoundation
import MixboxIpc

public final class PollingSynchronousIpcClient: SynchronousIpcClient {
    private let ipcClient: IpcClient
    
    public init(ipcClient: IpcClient) {
        self.ipcClient = ipcClient
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
        
        waitWhile { result == nil }
        
        return result ?? .error(ErrorString("noResponse"))
    }
    
    private func waitWhile(_ condition: () -> Bool) {
        var delayIntervals = [0.05, 0.1, 0.2, 0.4, 1, 5]
        
        while condition() {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: delayIntervals[0]))
            if delayIntervals.count > 1 {
                delayIntervals = Array(delayIntervals.dropFirst())
            }
        }
    }
}
