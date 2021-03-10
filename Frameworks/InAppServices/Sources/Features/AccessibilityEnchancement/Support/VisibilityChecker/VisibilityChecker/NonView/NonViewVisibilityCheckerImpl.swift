#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxTestability
import MixboxUiKit

public final class NonViewVisibilityCheckerImpl: NonViewVisibilityChecker {
    private let screen: UIScreen
    
    public init(screen: UIScreen) {
        self.screen = screen
    }
    
    public func checkVisibility(element: TestabilityElement) throws -> NonViewVisibilityCheckerResult {
        if isDefinitelyHidden(element: element) {
            return notVisibleResult()
        }

        let searchRectInScreenCoordinates = element.mb_testability_frameRelativeToScreen()

        let screenBounds = screen.bounds

        guard let searchRectAndScreenIntersection = searchRectInScreenCoordinates.mb_intersectionOrNil(screenBounds) else {
            return notVisibleResult()
        }
        
        let percentageOfIntersection = searchRectAndScreenIntersection.mb_area / searchRectInScreenCoordinates.mb_area
        
        return NonViewVisibilityCheckerResult(
            percentageOfVisibleArea: percentageOfIntersection
        )
    }
    
    private func notVisibleResult() -> NonViewVisibilityCheckerResult {
        return NonViewVisibilityCheckerResult(
            percentageOfVisibleArea: 0
        )
    }
    
    private func isDefinitelyHidden(element: TestabilityElement) -> Bool {
        let alphaThreshold: CGFloat = 0.01
        var pointer: TestabilityElement? = element
        
        while let element = pointer {
            let isHidden: Bool
            
            // TODO (non-view elements): Per-pixel check if view is on screen. Maybe to share code for views and non-views.
            if let view = element as? UIView {
                isHidden = view.isHidden
                    || view.alpha < alphaThreshold
                    || view.frame.mb_area <= 0
            } else {
                isHidden = element.mb_testability_isDefinitelyHidden()
                    || element.mb_testability_frame().mb_area <= 0
            }
            
            if isHidden {
                return true
            }
        
            pointer = element.mb_testability_parent()
        }
        
        return false
    }
}

#endif
