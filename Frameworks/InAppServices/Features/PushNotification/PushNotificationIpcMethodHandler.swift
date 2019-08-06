#if MIXBOX_ENABLE_IN_APP_SERVICES

import Foundation
import MixboxIpc
import MixboxIpcCommon
import MixboxFoundation

final class PushNotificationIpcMethodHandler: IpcMethodHandler {
    let method = PushNotificationIpcMethod()
    
    func handle(
        arguments: PushNotificationIpcMethod.Arguments,
        completion: @escaping (PushNotificationIpcMethod.ReturnValue) -> ())
    {
        guard
            let data = arguments.data(using: .utf8),
            let anyNotification = try? JSONSerialization.jsonObject(with: data),
            let notification = anyNotification as? [AnyHashable: Any]
            else
        {
            completion(
                IpcThrowingFunctionResult.threw(
                    ErrorString("Не удалось получить уведомление из полученой строки")
                )
            )
            return
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.delegate?.application?(
                UIApplication.shared,
                didReceiveRemoteNotification: notification
            )
            
            completion(IpcThrowingFunctionResult.returned(IpcVoid()))
        }
    }
}

#endif
