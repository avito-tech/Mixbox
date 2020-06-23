#if MIXBOX_ENABLE_IN_APP_SERVICES

import Foundation
import MixboxFoundation
import QuartzCore
import ObjectiveC.runtime

private typealias AnimationDidStartFunction = @convention(c) (AnyObject, Selector, CAAnimation?) -> Void
private typealias AnimationDidFinishFunction = @convention(c) (AnyObject, Selector, CAAnimation?, Bool) -> Void

private func AnimationDidStart(
    self: SurrogateCAAnimationDelegate,
    animation: CAAnimation?,
    isInvokedFromSwizzledMethod: Bool
) {
    animation?.mb_state = .started
    
    if !isInvokedFromSwizzledMethod {
        let selector = #selector(SurrogateCAAnimationDelegate.mbswizzled_animationDidStart(_:))
        let originalImp = class_getMethodImplementation(type(of: self), selector)
        unsafeBitCast(originalImp, to: AnimationDidStartFunction.self)(self, selector, animation)
    }
}

private func AnimationDidStop(
    self: SurrogateCAAnimationDelegate,
    animation: CAAnimation?,
    finished: Bool,
    isInvokedFromSwizzledMethod: Bool
) {
    animation?.mb_state = .stopped
    
    if !isInvokedFromSwizzledMethod {
        let selector = #selector(SurrogateCAAnimationDelegate.mbswizzled_animationDidStop(_:finished:))
        let originalImp = class_getMethodImplementation(type(of: self), selector)
        unsafeBitCast(originalImp, to: AnimationDidFinishFunction.self)(self, selector, animation, finished)
    }
}

private func AddInstanceMethodToClass(
    destinationClass: AnyClass,
    selector: Selector,
    sourceClass: AnyClass
) {
    guard let instanceMethod = class_getInstanceMethod(sourceClass, selector) else {
        fatalError("Instance method: \(selector) does not exist in the class \(sourceClass).")
    }
    
    let typeEncoding = method_getTypeEncoding(instanceMethod)
    let success = class_addMethod(
        destinationClass,
        selector,
        method_getImplementation(instanceMethod),
        typeEncoding
    )
    precondition(success, "Failed to add method: \(selector) to class: \(destinationClass)")
}

private func InstrumentSurrogateDelegate(
    selfClass: AnyClass,
    delegate: NSObject & CAAnimationDelegate,
    originalSelector: Selector,
    swizzledSelector: Selector,
    selfImplementation: IMP,
    delegateImplementation: IMP,
    swizzler: Swizzler
) -> NSObject & CAAnimationDelegate {
    guard !delegate.responds(to: swizzledSelector) else {
        return delegate
    }
    
    let delegateClass = type(of: delegate)
    
    if !delegate.responds(to: originalSelector) {
        AddInstanceMethodToClass(
            destinationClass: delegateClass,
            selector: originalSelector,
            sourceClass: selfClass
        )
    } else if selfImplementation != delegateImplementation {
        AddInstanceMethodToClass(
            destinationClass: delegateClass,
            selector: swizzledSelector,
            sourceClass: selfClass
        )
        
        let swizzlingResult = swizzler.swizzle(
            delegateClass,
            delegateClass,
            originalSelector,
            swizzledSelector,
            .instanceMethod
        )
        if !swizzlingResult.isSuccessful {
            fatalError("\(#file):\(#line): failed to swizzle \(originalSelector) to \(swizzledSelector) on \(delegateClass)")
        }
    }
    
    return delegate
}

@objc class SurrogateCAAnimationDelegate: NSObject, CAAnimationDelegate {
    
    override private init() {
        super.init()
    }
    
    static func surrogateDelegate(
        delegate: CAAnimationDelegate?
    ) -> CAAnimationDelegate {
        guard let delegate = delegate as? (NSObject & CAAnimationDelegate) else {
            return SurrogateCAAnimationDelegate()
        }
        
        let animationDidStartSEL = #selector(CAAnimationDelegate.animationDidStart(_:))
        let mbAnimationDidStartSEL = #selector(SurrogateCAAnimationDelegate.mbswizzled_animationDidStart(_:))
        let animationDidStopSEL = #selector(CAAnimationDelegate.animationDidStop(_:finished:))
        let mbAnimationDidStopSEL = #selector(SurrogateCAAnimationDelegate.mbswizzled_animationDidStop(_:finished:))
        
        guard let animationDidStartInstance = self.instanceMethod(for: animationDidStartSEL) else {
            fatalError("\(#file):\(#line): cannot find instance method \(animationDidStartSEL) for \(self)")
        }
        guard let animationDidStopInstance = self.instanceMethod(for: animationDidStopSEL) else {
            fatalError("\(#file):\(#line): cannot find instance method \(animationDidStopSEL) for \(self)")
        }
        
        guard let delegateAnimationDidStartInstance = delegate.method(for: animationDidStartSEL) else {
            fatalError("\(#file):\(#line): cannot find instance method \(animationDidStartSEL) for \(delegate)")
        }
        guard let delegateAnimationDidStopInstance = delegate.method(for: animationDidStopSEL) else {
            fatalError("\(#file):\(#line): cannot find instance method \(animationDidStopSEL) for \(delegate)")
        }
        
        let swizzler: Swizzler = SwizzlerImpl()
        
        var outDelegate: (NSObject & CAAnimationDelegate)
        
        outDelegate = InstrumentSurrogateDelegate(
            selfClass: SurrogateCAAnimationDelegate.self,
            delegate: delegate,
            originalSelector: animationDidStartSEL,
            swizzledSelector: mbAnimationDidStartSEL,
            selfImplementation: animationDidStartInstance,
            delegateImplementation: delegateAnimationDidStartInstance,
            swizzler: swizzler
        )
        outDelegate = InstrumentSurrogateDelegate(
            selfClass: SurrogateCAAnimationDelegate.self,
            delegate: outDelegate,
            originalSelector: animationDidStopSEL,
            swizzledSelector: mbAnimationDidStopSEL,
            selfImplementation: animationDidStopInstance,
            delegateImplementation: delegateAnimationDidStopInstance,
            swizzler: swizzler
        )
        
        return outDelegate
    }
    
    @objc func animationDidStart(_ anim: CAAnimation?) {
        AnimationDidStart(self: self, animation: anim, isInvokedFromSwizzledMethod: false)
    }
    
    @objc func animationDidStop(_ anim: CAAnimation?, finished flag: Bool) {
        AnimationDidStop(self: self, animation: anim, finished: flag, isInvokedFromSwizzledMethod: false)
    }
    
    @objc fileprivate func mbswizzled_animationDidStart(_ anim: CAAnimation?) {
        AnimationDidStart(self: self, animation: anim, isInvokedFromSwizzledMethod: true)
    }
    
    @objc fileprivate func mbswizzled_animationDidStop(_ anim: CAAnimation?, finished flag: Bool) {
        AnimationDidStop(self: self, animation: anim, finished: flag, isInvokedFromSwizzledMethod: true)
    }
}

#endif
