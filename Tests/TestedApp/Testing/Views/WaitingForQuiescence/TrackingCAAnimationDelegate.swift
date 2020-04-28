import Foundation
import QuartzCore

final class TrackingCAAnimationDelegate: NSObject, CAAnimationDelegate {
    var onStart: (CAAnimation) -> ()
    var onFinish: (CAAnimation, Bool) -> ()

    init(
        onStart: @escaping (CAAnimation) -> (),
        onFinish: @escaping (CAAnimation, Bool) -> ()
    ) {
        self.onStart = onStart
        self.onFinish = onFinish
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        onStart(anim)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        onFinish(anim, flag)
    }
}
