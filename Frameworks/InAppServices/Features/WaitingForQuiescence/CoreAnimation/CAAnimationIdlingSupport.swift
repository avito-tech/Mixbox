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
        if let uiViewAnimationStateClass = NSClassFromString("UIViewAnimationState") as? NSObject.Type {
            swizzle(
                class: uiViewAnimationStateClass,
                originalSelector: Selector(privateName: "_transferAnimationToTrackingAnimator:"),
                swizzledSelector: #selector(NSObject.mbswizzled__transferAnimationToTrackingAnimator(_:))
            )
            
            assertionFailureRecorder.recordAssertionFailure(
                message:
                """
                Class UIViewAnimationState was not found. \
                If tests are passing then it is no longer needed and \
                you should remove all related code.
                """
            )
        }
        
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

private class Marker {}

extension NSObject {
    // We need to track if we are in _transferAnimationToTrackingAnimator(_:) method to avoid this assertion:
    // "Attempting to transfer an animation to an animation state that does not belong to a property animator."
    //
    // This is the only place with the issue. Disassembled code (simplified):
    //
    // ```
    // rbx = [[r14 delegate] retain];
    // r15 = r13->_nextState;
    //
    // COND = rbx == r15;
    // if (!COND) {
    //     ...assertion failure...
    // ```
    //
    // `UIViewAnimationState` makes the assumption that the delegate of any CAAnimation is `UIViewAnimationState`
    // It compares CAAnimationDelegate with UIViewAnimationState and fails if they are not equal.
    //
    // The same issue was fixed in EarlGrey here:
    // https://github.com/google/EarlGrey/commit/de67ded30fd2a4d3505758d383559556eb963b74
    //
    // They made a "surrogate delagate" (whatever it means), which is actually the same instance as an original delegate,
    // but with swizzled methods. So they've just patched same instance and == operator inside
    // `_transferAnimationToTrackingAnimator` started to work properly.
    //
    // Unfortunately we got EXC_BAD_ACCESS in a real application (the issue was not reproduced in Mixbox/Tests)
    // Unable to debug it quickly, we simplified everything:
    //
    // - We made simple interceptor of CAAnimation in pure Swift (TrackingAnimationDelegate)
    // - We are tracking if we are inside `_transferAnimationToTrackingAnimator`
    //
    // This seems to be enough, because it is not correct to make such assumptions as in that function
    // and we think that is a rare case and this is the only place when such assumption was made
    // (and it is exactly a single place with that assertion failure).
    //
    @objc fileprivate func mbswizzled__transferAnimationToTrackingAnimator(_ animation: CAAnimation?) {
        // This method is called on main thread. It is okay to store a marker inside CAAnimation
        // to indicate that `_transferAnimationToTrackingAnimator` is somewhere in the callstack.
        // In case of Obj-C exception the marker is stored weakly, so even if it wasn't reset in the function below,
        // it would be reset automatically.
        let marker = Marker()
        
        withExtendedLifetime(marker) {
            animation?.isInsideTransferAnimationToTrackingAnimatorMarker.value = WeakBox<Marker>(marker)
            
            mbswizzled__transferAnimationToTrackingAnimator(animation)
            
            animation?.isInsideTransferAnimationToTrackingAnimatorMarker.value = nil
        }
    }
}

extension CAAnimation {
    @objc fileprivate func mbswizzled_delegate() -> CAAnimationDelegate? {
        if isInsideTransferAnimationToTrackingAnimator {
            return mbswizzled_delegate()
        } else {
            return TrackingAnimationDelegate(
                originalDelegate: mbswizzled_delegate()
            )
        }
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
    
    private var isInsideTransferAnimationToTrackingAnimator: Bool {
        return isInsideTransferAnimationToTrackingAnimatorMarker.value?.value != nil
    }
    
    fileprivate var isInsideTransferAnimationToTrackingAnimatorMarker: AssociatedObject<WeakBox<Marker>> {
        return AssociatedObject(container: self, key: #function)
    }
    
    private var animationTrackedIdlingResource: AssociatedObject<TrackedIdlingResource> {
        return AssociatedObject(container: self, key: #function)
    }
    
    private var stateAssociatedValue: AssociatedValue<CAAnimationState> {
        return AssociatedValue(container: self, key: #function, defaultValue: .pendingStart)
    }
}

#endif
