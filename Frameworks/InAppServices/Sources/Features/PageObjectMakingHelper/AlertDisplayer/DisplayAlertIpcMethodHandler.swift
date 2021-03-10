#if MIXBOX_ENABLE_IN_APP_SERVICES

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
