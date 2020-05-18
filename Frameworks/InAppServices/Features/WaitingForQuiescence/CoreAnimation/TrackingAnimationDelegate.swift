#if MIXBOX_ENABLE_IN_APP_SERVICES

class TrackingAnimationDelegate: NSObject, CAAnimationDelegate {
    // swiftlint:disable:next weak_delegate
    private let originalDelegate: CAAnimationDelegate?
    
    init(originalDelegate: CAAnimationDelegate?) {
        self.originalDelegate = originalDelegate
    }
    
    func animationDidStart(_ animation: CAAnimation) {
        animation.mb_state = .started
        
        originalDelegate?.animationDidStart?(animation)
    }
    
    func animationDidStop(_ animation: CAAnimation, finished: Bool) {
        originalDelegate?.animationDidStop?(animation, finished: finished)
        
        animation.mb_state = .stopped
    }
}

#endif
