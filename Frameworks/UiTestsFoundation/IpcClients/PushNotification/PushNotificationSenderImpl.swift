import Foundation
import MixboxIpc
import MixboxIpcCommon
import MixboxFoundation

public final class PushNotificationSenderImpl: PushNotificationSender {
    private let ipcClient: SynchronousIpcClient
    
    public init(ipcClient: SynchronousIpcClient) {
        self.ipcClient = ipcClient
    }
    
    // TODO: Remove extra serialization/deserialization, use typed IpcMethod arguments, write tests
    public func send(pushNotification: [AnyHashable: Any]) throws {
        guard
            let jsonData = try? JSONSerialization.data(withJSONObject: pushNotification),
            let jsonString = String(data: jsonData, encoding: .utf8)
            else
        {
            throw ErrorString("Couldn't serialize pushNotification dictionary to JSON")
        }
        
        let result = try ipcClient.callOrThrow(
            method: PushNotificationIpcMethod(),
            arguments: jsonString
        )
        
        try result.getVoidReturnValue()
    }
}
