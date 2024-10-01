#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import UIKit

public final class TouchDrawer: UiEventObserver {
    private var fadeOutViews = [FadeOutView]()
    
    public init() {
    }
    
    public func eventWasSent(event: UIEvent, window: UIWindow) -> UiEventObserverResult {
        handleEventWasSent(event: event, window: window)
        
        return UiEventObserverResult(shouldConsumeEvent: false)
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    private func handleEventWasSent(event: UIEvent, window: UIWindow) {
        guard let touches = event.allTouches else { return }
        
        guard let touch = touches.first else { return }
        
        switch touch.phase {
        case .began:
            addFadeOutViews(touches: touches, window: window)
        case .moved:
            removeFadeOutViews()
            addFadeOutViews(touches: touches, window: window)
        case .cancelled:
            removeFadeOutViews()
        case .ended:
            removeFadeOutViews()
        case .stationary:
            break
        // TODO: Figure out behavior for these:
        case .regionEntered:
            break
        case .regionExited:
            break
        case .regionMoved:
            break
        @unknown default:
            break
        }
    }
    
    private func addFadeOutViews(touches: Set<UITouch>, window: UIWindow) {
        for touch in touches {
            let fadeOutView = FadeOutView()
            fadeOutView.center = touch.location(in: window)
            window.addSubview(fadeOutView)
            fadeOutViews.append(fadeOutView)
        }
    }
    
    private func removeFadeOutViews() {
        for fadeOutView in fadeOutViews {
            fadeOutView.fadeOut()
        }
        
        self.fadeOutViews.removeAll()
    }
}

#endif
