#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon

final class GetUiScreenMainBoundsIpcMethodHandler: IpcMethodHandler {
    let method = GetUiScreenMainBoundsIpcMethod()
    
    init() {
    }
    
    func handle(
        arguments: GetUiScreenMainBoundsIpcMethod.Arguments,
        completion: @escaping (GetUiScreenMainBoundsIpcMethod.ReturnValue) -> ())
    {
        DispatchQueue.main.async {
            completion(UIScreen.main.bounds)
        }
    }
}

#endif
