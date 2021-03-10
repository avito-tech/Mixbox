#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon

final class GetUiScreenMainScaleIpcMethodHandler: IpcMethodHandler {
    let method = GetUiScreenMainScaleIpcMethod()
    
    init() {
    }
    
    func handle(
        arguments: GetUiScreenMainScaleIpcMethod.Arguments,
        completion: @escaping (GetUiScreenMainScaleIpcMethod.ReturnValue) -> ())
    {
        DispatchQueue.main.async {
            completion(UIScreen.main.scale)
        }
    }
}

#endif
