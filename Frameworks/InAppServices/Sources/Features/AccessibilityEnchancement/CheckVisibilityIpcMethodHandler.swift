#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import UIKit
import MixboxIpc
import MixboxIpcCommon
import MixboxFoundation
import MixboxTestability
#if SWIFT_PACKAGE
import MixboxTestabilityObjc
#endif
import MixboxUiKit

final class CheckVisibilityIpcMethodHandler: IpcMethodHandler {
    let method = CheckVisibilityIpcMethod()
    
    private let viewVisibilityChecker: ViewVisibilityChecker
    private let nonViewVisibilityChecker: NonViewVisibilityChecker
    private let iosVersionProvider: IosVersionProvider
    private let accessibilityUniqueObjectMap: AccessibilityUniqueObjectMap
    
    init(
        viewVisibilityChecker: ViewVisibilityChecker,
        nonViewVisibilityChecker: NonViewVisibilityChecker,
        iosVersionProvider: IosVersionProvider,
        accessibilityUniqueObjectMap: AccessibilityUniqueObjectMap
    ) {
        self.viewVisibilityChecker = viewVisibilityChecker
        self.nonViewVisibilityChecker = nonViewVisibilityChecker
        self.iosVersionProvider = iosVersionProvider
        self.accessibilityUniqueObjectMap = accessibilityUniqueObjectMap
    }
    
    func handle(
        arguments: CheckVisibilityIpcMethod.Arguments,
        completion: @escaping (CheckVisibilityIpcMethod.ReturnValue) -> ())
    {
        DispatchQueue.main.async { [accessibilityUniqueObjectMap] in
            let uniqueIdentifier = arguments.elementUniqueIdentifier
            
            guard let element = accessibilityUniqueObjectMap.locate(uniqueIdentifier: uniqueIdentifier) else {
                completion(.error(ErrorString(
                    "Failed to locate element with id '\(uniqueIdentifier)' in AccessibilityUniqueObjectMap"
                )))
                return
            }
            
            self.checkVisibility(element: element, arguments: arguments, completion: completion)
        }
    }
    
    private func checkVisibility(
        element: TestabilityElement,
        arguments: CheckVisibilityIpcMethod.Arguments,
        completion: @escaping (CheckVisibilityIpcMethod.ReturnValue) -> ())
    {
        if let view = element as? UIView {
            if shouldUseViewVisibilityChecker(view: view) {
                checkVisibilityOfView(view: view, arguments: arguments, completion: completion)
            } else {
                checkVisibilityOfNonView(element: element, arguments: arguments, completion: completion)
            }
        } else {
            checkVisibilityOfNonView(element: element, arguments: arguments, completion: completion)
        }
    }
    
    // Kludge for keyboard for iOS 16+.
    // Screenshot of keyboard can not be captured on iOS 16+.
    // This means that we can't use normal visiblity checker, because the view is not visible on screenshots.
    private func shouldUseViewVisibilityChecker(view: UIView) -> Bool {
        guard iosVersionProvider.iosVersion().majorVersion >= MixboxIosVersions.Supported.iOS16 else {
            // No problems on iOS 15
            return true
        }
        
        guard let window = view.window else {
            // Still ok to delegate responsibility to ViewVisibilityChecker
            return true
        }
        
        guard let remoteKeyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow") else {
            // Can't apply kludge
            return true
        }
          
        return !window.isKind(of: remoteKeyboardWindowClass)
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
