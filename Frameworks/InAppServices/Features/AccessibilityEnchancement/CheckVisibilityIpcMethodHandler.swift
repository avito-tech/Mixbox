#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon
import MixboxFoundation
import MixboxTestability

final class CheckVisibilityIpcMethodHandler: IpcMethodHandler {
    let method = CheckVisibilityIpcMethod()
    
    private let viewVisibilityChecker: ViewVisibilityChecker
    private let nonViewVisibilityChecker: NonViewVisibilityChecker
    
    init(viewVisibilityChecker: ViewVisibilityChecker, nonViewVisibilityChecker: NonViewVisibilityChecker) {
        self.viewVisibilityChecker = viewVisibilityChecker
        self.nonViewVisibilityChecker = nonViewVisibilityChecker
    }
    
    func handle(
        arguments: CheckVisibilityIpcMethod.Arguments,
        completion: @escaping (CheckVisibilityIpcMethod.ReturnValue) -> ())
    {
        let uniqueIdentifier = arguments.elementUniqueIdentifier
        
        guard let element = AccessibilityUniqueObjectMap.shared.locate(uniqueIdentifier: uniqueIdentifier) else {
            completion(.error(ErrorString(
                "Failed to locate element with id '\(uniqueIdentifier)' in AccessibilityUniqueObjectMap"
            )))
            return
        }
        
        checkVisibility(element: element, arguments: arguments, completion: completion)
    }
    
    private func checkVisibility(
        element: TestabilityElement,
        arguments: CheckVisibilityIpcMethod.Arguments,
        completion: @escaping (CheckVisibilityIpcMethod.ReturnValue) -> ())
    {
        if let view = element as? UIView {
            checkVisibilityOfView(view: view, arguments: arguments, completion: completion)
        } else {
            checkVisibilityOfNonView(element: element, arguments: arguments, completion: completion)
        }
    }
    
    private func checkVisibilityOfView(
        view: UIView,
        arguments: CheckVisibilityIpcMethod.Arguments,
        completion: @escaping (CheckVisibilityIpcMethod.ReturnValue) -> ())
    {
        DispatchQueue.main.async { [viewVisibilityChecker] in
            do {
                let visibilityCheckerResult = try viewVisibilityChecker.checkVisibility(
                    arguments: ViewVisibilityCheckerArguments(
                        view: view,
                        interactionCoordinates: arguments.interactionCoordinates,
                        useHundredPercentAccuracy: arguments.useHundredPercentAccuracy
                    )
                )
                
                completion(
                    .view(
                        CheckVisibilityIpcMethod.ViewVisibilityResult(
                            percentageOfVisibleArea: visibilityCheckerResult.percentageOfVisibleArea,
                            visibilePointOnScreenClosestToInteractionCoordinates: visibilityCheckerResult.visibilePointOnScreenClosestToInteractionCoordinates
                        )
                    )
                )
            } catch {
                completion(
                    .error(ErrorString(error))
                )
            }
        }
    }
    
    private func checkVisibilityOfNonView(
        element: TestabilityElement,
        arguments: CheckVisibilityIpcMethod.Arguments,
        completion: @escaping (CheckVisibilityIpcMethod.ReturnValue) -> ())
    {
        DispatchQueue.main.async { [nonViewVisibilityChecker] in
            do {
                let visibilityCheckerResult = try nonViewVisibilityChecker.checkVisibility(
                    element: element
                )
                
                completion(
                    .nonView(
                        CheckVisibilityIpcMethod.NonViewVisibilityResult(
                            percentageOfVisibleArea: visibilityCheckerResult.percentageOfVisibleArea
                        )
                    )
                )
            } catch {
                completion(
                    .error(ErrorString(error))
                )
            }
        }
    }
}

#endif
