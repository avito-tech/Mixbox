#if MIXBOX_ENABLE_IN_APP_SERVICES

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
        
        #if compiler(>=5.3)
        // Xcode 12+
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
        #else
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
        @unknown default:
            break
        }
        #endif
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
