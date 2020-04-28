#if MIXBOX_ENABLE_IN_APP_SERVICES

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
        trackCoreAnimationIdlingResourceChange { $0.trackedCoreAnimationLayoutPassState }
        mbswizzled_setNeedsDisplay()
    }
    
    @objc func mbswizzled_setNeedsDisplayInRect(_ r: CGRect) {
        trackCoreAnimationIdlingResourceChange { $0.trackedCoreAnimationLayoutPassState }
        mbswizzled_setNeedsDisplayInRect(r)
    }
    
    @objc func mbswizzled_setNeedsLayout() {
        trackCoreAnimationIdlingResourceChange { $0.trackedCoreAnimationLayoutPassState }
        mbswizzled_setNeedsLayout()
    }
    
    @objc func mbswizzled_add(animation: CAAnimation, key: String) {
        mb_adjustAnimationToAllowableRange(animation: animation)
        
        trackCoreAnimationIdlingResourceChange { $0.trackedCoreAnimationLayerState }

        mbswizzled_add(animation: animation, key: key)
    }
    
    @objc func mbswizzled_set(speed: CGFloat) {
        if speed == 0 && self.speed != 0 {
            mb_pauseAnimations()
        } else if speed != 0 && self.speed == 0 {
            mb_resumeAnimations()
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
    
    private var mb_caLayerModifyAnimations: Bool { true }
    private var mb_maxAllowableAnimationDuration: CFTimeInterval { 10 }
    
    func mb_adjustAnimationToAllowableRange(animation: CAAnimation) {
        guard mb_caLayerModifyAnimations else { return }
        
        if animation.duration > mb_maxAllowableAnimationDuration {
            animation.duration = mb_maxAllowableAnimationDuration
        }
        
        if animation.duration != 0 {
            let allowableRepeatDuration = mb_maxAllowableAnimationDuration - animation.duration
            let allowableRepeatCount: Float = Float(allowableRepeatDuration / animation.duration)
            if animation.repeatDuration > allowableRepeatDuration {
                animation.repeatDuration = allowableRepeatDuration
            } else if animation.repeatCount > allowableRepeatCount {
                animation.repeatCount = allowableRepeatCount
            }
        }
    }
    
    func mb_pauseAnimations() {
        guard let animationKeys = self.animationKeys(), !animationKeys.isEmpty else { return }
        
        for key in animationKeys {
            if let animation = self.animation(forKey: key) {
                animation.mb_untrack()
                mb_pausedAnimationKeys.value?.add(animation)
            }
        }
        
        for sublayer in sublayers ?? [] {
            sublayer.mb_pauseAnimations()
        }
    }
    
    func mb_resumeAnimations() {
        let pausedAnimationKeys = mb_pausedAnimationKeys.value ?? NSMutableSet()
        for key in pausedAnimationKeys {
            if let stringKey = key as? String {
                if let animation = self.animation(forKey: stringKey) {
                    if animation.mb_MBCAAnimationState == .started {
                        animation.mb_trackForDurationOfAnimation()
                    }
                }
            }
        }
        
        mb_pausedAnimationKeys.value?.removeAllObjects()
        
        for sublayer in sublayers ?? [] where sublayer.speed != 0 {
            sublayer.mb_resumeAnimations()
        }
    }
    
    private var mb_pausedAnimationKeys: AssociatedObject<NSMutableSet> {
        let object = AssociatedObject<NSMutableSet>(container: self, key: #function)
        if object.value == nil {
            object.value = NSMutableSet()
        }
        return object
    }
    
    private var trackedCoreAnimationLayerState: AssociatedObject<TrackedIdlingResource> {
        return AssociatedObject(container: self, key: #function)
    }
    
    private var trackedCoreAnimationLayoutPassState: AssociatedObject<TrackedIdlingResource> {
        return AssociatedObject(container: self, key: #function)
    }
    
    private func trackCoreAnimationIdlingResourceChange(
        trackedIdlingResource: @escaping (CALayer) -> AssociatedObject<TrackedIdlingResource>
    ) {
        trackedIdlingResource(self).value = IdlingResourceObjectTracker.instance.track(parent: self)
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            trackedIdlingResource(strongSelf).value?.untrack()
        }
    }
}

#endif
