#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation
import UIKit
import MixboxUiKit

// Rewritten from Objective-C to Swift:
// https://github.com/google/EarlGrey/blob/91c27bb8a15e723df974f620f7f576a30a6a7484/EarlGrey/Additions/CAAnimation%2BGREYAdditions.m
// Was heavily modified since then.
//
final class CAAnimationIdlingSupport {
    private let assertingSwizzler: AssertingSwizzler
    private let assertionFailureRecorder: AssertionFailureRecorder
    
    init(
        assertingSwizzler: AssertingSwizzler,
        assertionFailureRecorder: AssertionFailureRecorder)
    {
        self.assertingSwizzler = assertingSwizzler
        self.assertionFailureRecorder = assertionFailureRecorder
    }
    
    func swizzle() {
        swizzle(
            class: CAAnimation.self,
            originalSelector: #selector(getter: CAAnimation.delegate),
            swizzledSelector: #selector(CAAnimation.mbswizzled_delegate)
        )
    }
    
    private func swizzle(
        class: NSObject.Type,
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
    @objc fileprivate func mbswizzled_delegate() -> CAAnimationDelegate? {
        return SurrogateCAAnimationDelegate.surrogateDelegate(
            delegate: mbswizzled_delegate()
        )
    }
    
    // Is used here and in `CALayerIdlingSupport` to track state of the animation.
    var mb_state: CAAnimationState {
        set {
            stateAssociatedValue.value = newValue
            
            switch newValue {
            case .started:
                mb_trackForDurationOfAnimation()
            case .stopped:
                mb_untrack()
            case .pendingStart:
                break
            }
        }
        get {
            return stateAssociatedValue.value
        }
    }
    
    func mb_trackForDurationOfAnimation() {
        animationTrackedIdlingResource.value = IdlingResourceObjectTracker.instance.track(parent: self)

        var animRuntimeTime = duration + Double(repeatCount) * duration + repeatDuration
        
        // Add extra padding to the animation runtime just as a safeguard. This comes into play when
        // animatonDidStop delegate is not invoked before the expected end-time is reached.
        // The state is then automatically cleared for this animation as it should have finished by now.
        animRuntimeTime += min(animRuntimeTime, 1.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animRuntimeTime) {
            self.mb_untrack()
        }
    }
    
    func mb_untrack() {
        animationTrackedIdlingResource.value?.untrack()
    }
    
    // MARK: - Private state
    
    private var animationTrackedIdlingResource: AssociatedObject<TrackedIdlingResource> {
        return AssociatedObject(container: self, key: #function)
    }
    
    private var stateAssociatedValue: AssociatedValue<CAAnimationState> {
        return AssociatedValue(container: self, key: #function, defaultValue: .pendingStart)
    }
}

#endif
