#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation
import UIKit
import MixboxUiKit

// Rewritten from Objective-C to Swift:
// https://github.com/google/EarlGrey/blob/91c27bb8a15e723df974f620f7f576a30a6a7484/EarlGrey/Additions/CAAnimation%2BGREYAdditions.m
//
final class CAAnimationIdlingSupport {
    private let assertingSwizzler: AssertingSwizzler
    
    init(assertingSwizzler: AssertingSwizzler) {
        self.assertingSwizzler = assertingSwizzler
    }
    
    func swizzle() {
        swizzle(
            originalSelector: #selector(setter: CAAnimation.delegate),
            swizzledSelector: #selector(CAAnimation.mbswizzled_setDelegate(_:))
        )
        
        swizzle(
            originalSelector: #selector(getter: CAAnimation.delegate),
            swizzledSelector: #selector(CAAnimation.mbswizzled_delegate)
        )
    }
    
    private func swizzle(
        class: NSObject.Type = CAAnimation.self,
        originalSelector: Selector,
        swizzledSelector: Selector
    ) {
        assertingSwizzler.swizzle(
            class: `class`,
            originalSelector: originalSelector,
            swizzledSelector: swizzledSelector,
            methodType: .instanceMethod,
            shouldAssertIfMethodIsSwizzledOnlyOneTime: true
        )
    }
}

extension CAAnimation {
    @objc fileprivate func mbswizzled_setDelegate(_ delegate: CAAnimationDelegate?) {
        let surrogate = SurrogateCAAnimationDelegate.surrogateDelegate(
            delegate: delegate
        )
        mbswizzled_setDelegate(surrogate)
    }
    
    @objc fileprivate func mbswizzled_delegate() -> CAAnimationDelegate? {
        let delegate = self.mbswizzled_delegate()
        
        return SurrogateCAAnimationDelegate.surrogateDelegate(
            delegate: delegate
        )
    }

    var mb_MBCAAnimationState: MBCAAnimationState {
        set {
            mb_animationState.value = newValue
            
            if newValue == .started {
                mb_trackForDurationOfAnimation()
            } else {
                mb_untrack()
            }
        }
        get {
            return mb_animationState.value
        }
    }
    
    @objc func mb_trackForDurationOfAnimation() {
        mb_animationTrackedIdlingResources.value = IdlingResourceObjectTracker.instance.track(parent: self)

        var animRuntimeTime = duration + Double(repeatCount) * duration + repeatDuration
        animRuntimeTime += min(animRuntimeTime, 1.0)
        perform(#selector(mb_untrack), with: nil, afterDelay: animRuntimeTime, inModes: [.common])
    }
    
    @objc func mb_untrack() {
        mb_animationTrackedIdlingResources.value?.untrack()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(mb_untrack), object: nil)
    }
    
    private var mb_animationTrackedIdlingResources: AssociatedObject<TrackedIdlingResource> {
        return AssociatedObject(container: self, key: #function)
    }
    
    private var mb_animationState: AssociatedValue<MBCAAnimationState> {
        return AssociatedValue(container: self, key: #function, defaultValue: .pendingStart)
    }
}

#endif
