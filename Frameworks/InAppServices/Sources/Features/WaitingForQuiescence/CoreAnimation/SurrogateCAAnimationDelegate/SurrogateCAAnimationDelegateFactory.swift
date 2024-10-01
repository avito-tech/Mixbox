#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import Foundation
import MixboxFoundation
import QuartzCore
import ObjectiveC.runtime
#if SWIFT_PACKAGE
import MixboxInAppServicesObjc
#endif

class SurrogateCAAnimationDelegateFactory {
    static func surrogateDelegate(
        delegate: CAAnimationDelegate?
    ) -> CAAnimationDelegate {
        guard let delegate = delegate as? (NSObject & CAAnimationDelegate) else {
            return SurrogateCAAnimationDelegateObjC()
        }
        
        let animationDidStartSEL = #selector(CAAnimationDelegate.animationDidStart(_:))
        let mbAnimationDidStartSEL = #selector(SurrogateCAAnimationDelegateObjC.mbswizzled_animationDidStart(_:))
        let animationDidStopSEL = #selector(CAAnimationDelegate.animationDidStop(_:finished:))
        let mbAnimationDidStopSEL = #selector(SurrogateCAAnimationDelegateObjC.mbswizzled_animationDidStop(_:finished:))
        
        guard let animationDidStartInstance = SurrogateCAAnimationDelegateObjC.instanceMethod(for: animationDidStartSEL) else {
            fatalError("\(#filePath):\(#line): cannot find instance method \(animationDidStartSEL) for \(self)")
        }
        guard let animationDidStopInstance = SurrogateCAAnimationDelegateObjC.instanceMethod(for: animationDidStopSEL) else {
            fatalError("\(#filePath):\(#line): cannot find instance method \(animationDidStopSEL) for \(self)")
        }
        
        guard let delegateAnimationDidStartInstance = delegate.method(for: animationDidStartSEL) else {
            fatalError("\(#filePath):\(#line): cannot find instance method \(animationDidStartSEL) for \(delegate)")
        }
        guard let delegateAnimationDidStopInstance = delegate.method(for: animationDidStopSEL) else {
            fatalError("\(#filePath):\(#line): cannot find instance method \(animationDidStopSEL) for \(delegate)")
        }
        
        let swizzler: Swizzler = SwizzlerImpl()
        
        var outDelegate: (NSObject & CAAnimationDelegate)
        
        outDelegate = instrumentSurrogateDelegate(
            selfClass: SurrogateCAAnimationDelegateObjC.self,
            delegate: delegate,
            originalSelector: animationDidStartSEL,
            swizzledSelector: mbAnimationDidStartSEL,
            selfImplementation: animationDidStartInstance,
            delegateImplementation: delegateAnimationDidStartInstance,
            swizzler: swizzler
        )
        outDelegate = instrumentSurrogateDelegate(
            selfClass: SurrogateCAAnimationDelegateObjC.self,
            delegate: outDelegate,
            originalSelector: animationDidStopSEL,
            swizzledSelector: mbAnimationDidStopSEL,
            selfImplementation: animationDidStopInstance,
            delegateImplementation: delegateAnimationDidStopInstance,
            swizzler: swizzler
        )
        
        return outDelegate
    }
    
    private static func instrumentSurrogateDelegate(
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
            addInstanceMethodToClass(
                destinationClass: delegateClass,
                selector: originalSelector,
                sourceClass: selfClass
            )
        } else if selfImplementation != delegateImplementation {
            addInstanceMethodToClass(
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
                fatalError("\(#filePath):\(#line): failed to swizzle \(originalSelector) to \(swizzledSelector) on \(delegateClass)")
            }
        }
        
        return delegate
    }
    
    private static func addInstanceMethodToClass(
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
}

#endif
