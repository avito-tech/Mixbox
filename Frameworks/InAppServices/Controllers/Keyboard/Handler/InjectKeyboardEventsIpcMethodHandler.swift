import MixboxIpc
import MixboxIpcCommon

final class InjectKeyboardEventsIpcMethodHandler: IpcMethodHandler {
    let method = InjectKeyboardEventsIpcMethod()
    
    private let keyboardEventInjector: KeyboardEventInjector
    
    init(keyboardEventInjector: KeyboardEventInjector) {
        self.keyboardEventInjector = keyboardEventInjector
    }
    
    func handle(arguments: [KeyboardEvent], completion: @escaping (IpcVoid) -> ()) {
        keyboardEventInjector.inject(events: arguments) {
            completion(IpcVoid())
        }
    }
}
