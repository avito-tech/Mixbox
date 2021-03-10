import MixboxIpcCommon
import MixboxIpc

public final class IpcAlertDisplayer: SynchronousAlertDisplayer {
    private let synchronousIpcClient: SynchronousIpcClient
    
    public init(synchronousIpcClient: SynchronousIpcClient) {
        self.synchronousIpcClient = synchronousIpcClient
    }
    
    public func display(alert: Alert) throws {
        let result = try synchronousIpcClient.callOrThrow(
            method: DisplayAlertIpcMethod(),
            arguments: alert
        )
        try result.getVoidReturnValue()
    }
}
