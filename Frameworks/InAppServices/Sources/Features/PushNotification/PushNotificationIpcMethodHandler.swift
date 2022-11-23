#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

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
