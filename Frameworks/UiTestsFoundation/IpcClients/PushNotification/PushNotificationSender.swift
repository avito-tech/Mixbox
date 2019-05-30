import Foundation
import MixboxIpc
import MixboxIpcCommon

public protocol PushNotificationSender: class {
    @discardableResult
    func send(pushNotification: [AnyHashable: Any]) -> IpcMethodCallingResult
}

public final class PushNotificationSenderImpl: PushNotificationSender {
    private let ipcClient: IpcClient
    
    public init(ipcClient: IpcClient) {
        self.ipcClient = ipcClient
    }
    
    public func send(pushNotification: [AnyHashable: Any]) -> IpcMethodCallingResult {
        guard
            let jsonData = try? JSONSerialization.data(withJSONObject: pushNotification),
            let jsonStrring = String(data: jsonData, encoding: .utf8)
            else {
                return .failure("Не удалось создать уведомление из словаря")
        }
        
        let result = ipcClient.call(
            method: PushNotificationIpcMethod(),
            arguments: jsonStrring
        )
        
        switch result {
        case .data(let data):
            return data
        case .error:
            return .failure("Не удалось получить ответ от аппа")
        }
    }
}
