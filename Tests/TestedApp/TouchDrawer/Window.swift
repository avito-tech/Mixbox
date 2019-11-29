import UIKit
import TestsIpc

class TouchDrawingWindow: UIWindow {
    private var fadeOutViews = [FadeOutView]()
    private let uiEventObserver: UiEventObserver
    
    init(frame: CGRect, uiEventObserver: UiEventObserver) {
        self.uiEventObserver = uiEventObserver
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sendEvent(_ event: UIEvent) {
        uiEventObserver.eventWasSent(event: event)
        
        super.sendEvent(event)
        
        guard let touches = event.allTouches
            else { return }
        
        guard let touch = touches.first
            else { return }
        
        switch touch.phase {
        case .began:
            addFadeOutViewsForTouches(touches)
            super.touchesBegan(touches, with: event)
            
        case .moved:
            removeFadeOutViews()
            addFadeOutViewsForTouches(touches)
            super.touchesMoved(touches, with: event)
            
        case .cancelled:
            removeFadeOutViews()
            super.touchesCancelled(touches, with: event)
            
        case .ended:
            removeFadeOutViews()
            super.touchesEnded(touches, with: event)
            
        case .stationary:
            break
            
        @unknown default:
            break
        }
    }
    
    private func addFadeOutViewsForTouches(_ touches: Set<UITouch>) {
        for touch in touches {
            let fadeOutView = FadeOutView()
            fadeOutView.center = touch.location(in: window)
            addSubview(fadeOutView)
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
