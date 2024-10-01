#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import Foundation
import MixboxIpc
import MixboxIpcCommon
import MixboxFoundation

final class DisplayAlertIpcMethodHandler: IpcMethodHandler {
    let method = DisplayAlertIpcMethod()
    
    private let alertDisplayer: InAppAlertDisplayer
    
    init(alertDisplayer: InAppAlertDisplayer) {
        self.alertDisplayer = alertDisplayer
    }
    
    func handle(
        arguments: DisplayAlertIpcMethod.Arguments,
        completion: @escaping (DisplayAlertIpcMethod.ReturnValue) -> ())
    {
        DispatchQueue.main.async { [alertDisplayer] in
            do {
                try alertDisplayer.display(alert: arguments) {
                    DispatchQueue.main.async {
                        completion(.returned(IpcVoid()))
                    }
                }
            } catch {
                completion(.threw(ErrorString(error)))
            }
        }
    }
}

#endif
