#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon
import MixboxFoundation

final class CheckVisibilityIpcMethodHandler: IpcMethodHandler {
    let method = CheckVisibilityIpcMethod()
    
    private let viewVisibilityChecker: ViewVisibilityChecker
    
    init(viewVisibilityChecker: ViewVisibilityChecker) {
        self.viewVisibilityChecker = viewVisibilityChecker
    }
    
    func handle(
        arguments: CheckVisibilityIpcMethod.Arguments,
        completion: @escaping (CheckVisibilityIpcMethod.ReturnValue) -> ())
    {
        let uniqueIdentifier = arguments.elementUniqueIdentifier
        
        guard let element = AccessibilityUniqueObjectMap.shared.locate(uniqueIdentifier: uniqueIdentifier) else {
            completion(IpcThrowingFunctionResult.threw(ErrorString("Failed to locate element with id '\(uniqueIdentifier)' in AccessibilityUniqueObjectMap")))
            return
        }
        
        guard let view = element as? UIView else {
            completion(IpcThrowingFunctionResult.threw(ErrorString("Element with id '\(uniqueIdentifier)' is not a UIView, can not perform visibility check")))
            return
        }
        
        DispatchQueue.main.async { [viewVisibilityChecker] in
            let result = IpcThrowingFunctionResult { () -> CheckVisibilityIpcMethod.Result in 
                let visibilityCheckerResult = try viewVisibilityChecker.checkVisibility(
                    arguments: VisibilityCheckerArguments(
                        view: view,
                        interactionCoordinates: arguments.interactionCoordinates
                    )
                )
                
                return CheckVisibilityIpcMethod.Result(
                    percentageOfVisibleArea: visibilityCheckerResult.percentageOfVisibleArea,
                    visibilePointOnScreenClosestToInteractionCoordinates: visibilityCheckerResult.visibilePointOnScreenClosestToInteractionCoordinates
                )
            }
            
            completion(result)
        }
    }
}

#endif
