#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

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
