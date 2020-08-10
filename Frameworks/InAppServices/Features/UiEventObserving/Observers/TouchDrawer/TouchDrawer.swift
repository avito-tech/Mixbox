#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class TouchDrawer: UiEventObserver {
    private var fadeOutViews = [FadeOutView]()
    
    public init() {
    }
    
    public func eventWasSent(event: UIEvent, window: UIWindow) {
        guard let touches = event.allTouches
            else { return }
        
        guard let touch = touches.first
            else { return }
        
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
