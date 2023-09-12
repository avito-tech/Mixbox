#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import Foundation
import MixboxFoundation
import QuartzCore

// Rewritten from Objective-C to Swift:
// https://github.com/google/EarlGrey/blob/91c27bb8a15e723df974f620f7f576a30a6a7484/EarlGrey/Additions/CALayer%2BGREYAdditions.m
//
final class CALayerIdlingSupport {
    private let assertingSwizzler: AssertingSwizzler
    
    init(assertingSwizzler: AssertingSwizzler) {
        self.assertingSwizzler = assertingSwizzler
    }
    
    func swizzle() {
        swizzle(
            originalSelector: #selector(CALayer.setNeedsDisplay as (CALayer) -> () -> Void),
            swizzledSelector: #selector(CALayer.mbswizzled_setNeedsDisplay)
        )

        swizzle(
            originalSelector: #selector(CALayer.setNeedsDisplay(_:)),
            swizzledSelector: #selector(CALayer.mbswizzled_setNeedsDisplayInRect(_:))
        )

        swizzle(
            originalSelector: #selector(CALayer.setNeedsLayout),
            swizzledSelector: #selector(CALayer.mbswizzled_setNeedsLayout)
        )

        swizzle(
            originalSelector: #selector(CALayer.add(_:forKey:)),
            swizzledSelector: #selector(CALayer.mbswizzled_add(animation:key:))
        )

        swizzle(
            originalSelector: #selector(setter: CALayer.speed),
            swizzledSelector: #selector(CALayer.mbswizzled_set(speed:))
        )

        swizzle(
            originalSelector: #selector(CALayer.removeAnimation(forKey:)),
            swizzledSelector: #selector(CALayer.mbswizzled_removeAnimation(key:))
        )

        swizzle(
            originalSelector: #selector(CALayer.removeAllAnimations),
            swizzledSelector: #selector(CALayer.mbswizzled_removeAllAnimations)
        )
    }
    
    private func swizzle(
        class: NSObject.Type = CALayer.self,
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

extension CALayer {
    @objc func mbswizzled_setNeedsDisplay() {
        // Next runloop drain will perform the draw pass.
        trackUntilNextRunloopDrain(
            methodDescription: "-CALayer.setNeedsDisplay()"
        )
        
        mbswizzled_setNeedsDisplay()
    }
    
    @objc func mbswizzled_setNeedsDisplayInRect(_ r: CGRect) {
        // Next runloop drain will perform the draw pass.
        trackUntilNextRunloopDrain(
            methodDescription: "-CALayer.setNeedsDisplay(_:)"
        )
        
        mbswizzled_setNeedsDisplayInRect(r)
    }
    
    @objc func mbswizzled_setNeedsLayout() {
        // Next runloop drain will perform the layout pass.
        trackUntilNextRunloopDrain(
            methodDescription: "-CALayer.setNeedsLayout()"
        )
        
        mbswizzled_setNeedsLayout()
    }
    
    @objc func mbswizzled_add(animation: CAAnimation, key: String) {
        adjustAnimationToAllowableRange(animation: animation)

        // At this point, the app could be in idle state and the next runloop drain may trigger this
        // animation so track this LAYER (not animation) until next runloop drain.
        trackUntilNextRunloopDrain(
            methodDescription: "CALayer.add(_:forKey:)"
        )

        mbswizzled_add(animation: animation, key: key)
    }
    
    @objc func mbswizzled_set(speed: CGFloat) {
        if speed == 0 && self.speed != 0 {
            handleLayerSpeedChangedToZero()
        } else if speed != 0 && self.speed == 0 {
            handleLayerSpeedChangedToNonZero()
        }
        
        mbswizzled_set(speed: speed)
    }
    
    @objc func mbswizzled_removeAnimation(key: String) {
        if let animation = self.animation(forKey: key) {
            animation.mb_untrack()
        }
        mbswizzled_removeAnimation(key: key)
    }
    
    @objc func mbswizzled_removeAllAnimations() {
        guard let animationKeys = self.animationKeys() else { return }
        for key in animationKeys {
            if let animation = self.animation(forKey: key) {
                animation.mb_untrack()
            }
        }
        mbswizzled_removeAllAnimations()
    }
    
    private var caLayerModifyAnimations: Bool { true }
    private var maxAllowableAnimationDuration: CFTimeInterval { 10 }
    
    private func adjustAnimationToAllowableRange(animation: CAAnimation) {
        guard caLayerModifyAnimations else { return }
        
        if animation.duration > maxAllowableAnimationDuration {
            animation.duration = maxAllowableAnimationDuration
        }
        
        if animation.duration != 0 {
            let allowableRepeatDuration = maxAllowableAnimationDuration - animation.duration
            let allowableRepeatCount: Float = Float(allowableRepeatDuration / animation.duration)
            if animation.repeatDuration > allowableRepeatDuration {
                animation.repeatDuration = allowableRepeatDuration
            } else if animation.repeatCount > allowableRepeatCount {
                animation.repeatCount = allowableRepeatCount
            }
        }
    }
    
    private func handleLayerSpeedChangedToZero() {
        guard let animationKeys = self.animationKeys(), !animationKeys.isEmpty else { return }
        
        pausedAnimationKeys.value = Set(animationKeys)
        
        for key in animationKeys {
            if let animation = self.animation(forKey: key) {
                animation.mb_untrack()
            }
        }
        
        for sublayer in sublayers ?? [] {
            sublayer.handleLayerSpeedChangedToZero()
        }
    }
    
    private func handleLayerSpeedChangedToNonZero() {
        for key in pausedAnimationKeys.value {
            guard let animation = self.animation(forKey: key) else {
                continue
            }
            
            switch animation.mb_state {
            case .started:
                animation.mb_trackForDurationOfAnimation(reason: "layer speed changed to non-zero and animation is in state `started`")
            case .stopped, .pendingStart:
                break
            }
        }
        
        pausedAnimationKeys.value = []
        
        for sublayer in sublayers ?? [] where sublayer.speed != 0 {
            sublayer.handleLayerSpeedChangedToNonZero()
        }
    }
    
    private var pausedAnimationKeys: AssociatedValue<Set<String>> {
        return AssociatedValue(container: self, key: #function, defaultValue: [])
    }
    
    private func trackUntilNextRunloopDrain(
        methodDescription: String
    ) {
        let trackedIdlingResource = IdlingResourceObjectTracker.instance.track(
            parent: self,
            resourceDescription: {
                TrackedIdlingResourceDescription(
                    name: methodDescription,
                    causeOfResourceBeingTracked: "`\(methodDescription)` was called",
                    likelyCauseOfResourceStillBeingTracked: "unknown", // seems to be impossible
                    listOfConditionsThatWillCauseResourceToBeUntracked: [
                        "main queue executes sheduled task"
                    ]
                )
            }
        )
        
        DispatchQueue.main.async {
            trackedIdlingResource.untrack()
        }
    }
}

#endif
