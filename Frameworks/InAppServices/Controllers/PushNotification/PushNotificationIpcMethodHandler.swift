#if MIXBOX_ENABLE_IN_APP_SERVICES

import Foundation
import MixboxIpc
import MixboxIpcCommon

final class PushNotificationIpcMethodHandler: IpcMethodHandler {
    let method = PushNotificationIpcMethod()
    
    func handle(arguments: String, completion: @escaping (IpcMethodCallingResult) -> ()) {
        
        guard
            let data = arguments.data(using: .utf8),
            let anyNotification = try? JSONSerialization.jsonObject(with: data),
            let notification = anyNotification as? [AnyHashable: Any]
            else {
                completion(.failure("Не удалось получить уведомление из полученой строки"))
                return
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.delegate?.application?(
                UIApplication.shared,
                didReceiveRemoteNotification: notification
            )
            
            completion(.success)
        }
    }
}

#endif
