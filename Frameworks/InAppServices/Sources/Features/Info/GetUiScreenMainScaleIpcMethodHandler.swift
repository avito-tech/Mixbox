#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

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
