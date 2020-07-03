#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon

final class PercentageOfVisibleAreaIpcMethodHandler: IpcMethodHandler {
    let method = PercentageOfVisibleAreaIpcMethod()
    
    private let visibilityChecker: VisibilityChecker
    
    init(visibilityChecker: VisibilityChecker) {
        self.visibilityChecker = visibilityChecker
    }
    
    func handle(arguments: String, completion: @escaping (CGFloat?) -> ()) {
        guard let view = AccessibilityUniqueObjectMap.shared.locate(uniqueIdentifier: arguments) as? UIView else {
            completion(nil)
            return
        }
        
        DispatchQueue.main.async { [visibilityChecker] in
            completion(
                visibilityChecker.percentElementVisible(view: view)
            )
        }
    }
}

#endif
