#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon

public final class PageObjectElementGenerationWizardImpl: PageObjectElementGenerationWizard, UiEventObserver {
    private let view: PageObjectElementGenerationWizardView
    private let viewHierarchyProvider: ViewHierarchyProvider
    
    private var onFinish: (() -> ())?
    
    private var touchPoint: CGPoint?
    private var viewHierarchy: ViewHierarchy?
    
    public init(
        view: PageObjectElementGenerationWizardView,
        viewHierarchyProvider: ViewHierarchyProvider)
    {
        self.view = view
        self.viewHierarchyProvider = viewHierarchyProvider
    }
    
    // MARK: - PageObjectElementGenerationWizard
    
    public func start() {
        viewHierarchy = viewHierarchyProvider.viewHierarchy()
    }
    
    public func set(onFinish: (() -> ())?) {
        self.onFinish = onFinish
    }
    
    // MARK: - UiEventObserver
    
    public func eventWasSent(event: UIEvent, window: UIWindow) -> UiEventObserverResult {
        handleEventWasSent(event: event, window: window)
        
        return UiEventObserverResult(shouldConsumeEvent: true)
    }
    
    private func handleEventWasSent(event: UIEvent, window: UIWindow) {
        guard let touches = event.allTouches
            else { return }
        
        guard let touch = touches.first
            else { return }
        
        switch touch.phase {
        case .began:
            touchPoint = touch.location(in: nil)
        case .moved, .cancelled, .stationary:
            break
        // TODO: Figure out behavior for these:
        case .regionEntered:
            break
        case .regionExited:
            break
        case .regionMoved:
            break
        case .ended:
            if let touchPoint = touchPoint, let viewHierarchy = self.viewHierarchy {
                handleTouchEnded(point: touchPoint, viewHierarchy: viewHierarchy)
            }
            touchPoint = nil
        @unknown default:
            break
        }
    }
    
    private func handleTouchEnded(point: CGPoint, viewHierarchy: ViewHierarchy) {
        let elements = intersectingViewHierarchyElements(
            point: point,
            elements: viewHierarchy.rootElements
        )
        
        // TBD
        let sortedElements = elements.sorted { (lhs, rhs) -> Bool in
            lhs.frameRelativeToScreen.mb_area < rhs.frameRelativeToScreen.mb_area
        }
        
        view.selectedRect = sortedElements.first?.frameRelativeToScreen
    }
    
    private func intersectingViewHierarchyElements(
        point: CGPoint,
        elements: [ViewHierarchyElement])
        -> [ViewHierarchyElement]
    {
        var intersectingElements = [ViewHierarchyElement]()
        
        for element in elements {
            if element.frameRelativeToScreen.contains(point) {
                intersectingElements.append(element)
            }
        }
        
        for element in elements {
            intersectingElements.append(
                contentsOf: intersectingViewHierarchyElements(
                    point: point,
                    elements: element.children
                )
            )
        }
        
        return intersectingElements
    }
}

#endif
