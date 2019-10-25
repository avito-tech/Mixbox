#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon

final class InjectKeyboardEventsIpcMethodHandler: IpcMethodHandler {
    let method = InjectKeyboardEventsIpcMethod()
    
    private let keyboardEventInjector: KeyboardEventInjector
    
    init(keyboardEventInjector: KeyboardEventInjector) {
        self.keyboardEventInjector = keyboardEventInjector
    }
    
    func handle(
        arguments: InjectKeyboardEventsIpcMethod.Arguments,
        completion: @escaping (InjectKeyboardEventsIpcMethod.ReturnValue) -> ())
    {
        keyboardEventInjector.inject(events: arguments) { error in
            let result: IpcThrowingFunctionResult<IpcVoid>
            
            if let error = error {
                result = .threw(error)
            } else {
                result = .returned(IpcVoid())
            }
            
            completion(result)
        }
    }
}

#endif
