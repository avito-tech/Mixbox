import MixboxIpcCommon
import MixboxIpc

public final class IpcAlertDisplayer: AlertDisplayer {
    private let synchronousIpcClient: SynchronousIpcClient
    
    public init(synchronousIpcClient: SynchronousIpcClient) {
        self.synchronousIpcClient = synchronousIpcClient
    }
    
    public func display(alert: Alert) throws {
        _ = try synchronousIpcClient.callOrThrow(
            method: DisplayAlertIpcMethod(),
            arguments: alert
        )
    }
}
