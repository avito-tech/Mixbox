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
        
        guard let element = AccessibilityUniqueObjectMap.shared.locate(uniqueIdentifier: viewId) else {
            completion(
                .internalError(
                    """
                    UI element \(viewId) was not found. This can happen if element deallocates or if it wasn't registered in \(AccessibilityUniqueObjectMap.self)
                    """
                )
            )
            return
        }
        
        guard let view = element as? UIView else {
            completion(.internalError(
                """
                UI element \(viewId) is not a view, scrolling to a non-view element is not supported yet. Note that scrolling is not necessary if element is visible on screen,
                if element is visible on screen, scrolling does not happen and this error is not raised.
                """
            ))
            return
        }
        
        DispatchQueue.main.async {
            let result = ScrollingHintsProvider.instance.scrollingHint(forScrollingToView: view)
            completion(result)
        }
    }
}

#endif
