#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon

final class SetPasteboardStringIpcMethodHandler: IpcMethodHandler {
    let method = SetPasteboardStringIpcMethod()
    
    func handle(arguments: String?, completion: @escaping (IpcVoid) -> ()) {
        UIPasteboard.general.string = arguments
        completion(IpcVoid())
    }
}

#endif
