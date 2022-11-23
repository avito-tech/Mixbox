#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxIpc
import MixboxIpcCommon

final class ScrollingHintIpcMethodHandler: IpcMethodHandler {
    let method = ScrollingHintIpcMethod()
    
    func handle(arguments: String, completion: @escaping (ScrollingHint) -> ()) {
        let viewId = arguments
        
        guard let view = AccessibilityUniqueObjectMap.shared.locate(uniqueIdentifier: viewId) as? UIView else {
            completion(.internalError("Вьюшка \(viewId) не найдена"))
            return
        }
        
        DispatchQueue.main.async {
            let result = ScrollingHintsProvider.instance.scrollingHint(forScrollingToView: view)
            completion(result)
        }
    }
}

#endif
