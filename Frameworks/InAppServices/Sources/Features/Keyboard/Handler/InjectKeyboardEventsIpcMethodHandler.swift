#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

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
