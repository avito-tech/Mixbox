#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import UIKit

// Swift logic for `SurrogateCAAnimationDelegateObjC`.
// Note that purpose of `SurrogateCAAnimationDelegateObjC` is solely to suppress warning
// about incorrect optionality (which is in fact very correct, and prevent crashes).
// It should be public to be able to be imported from Obj-C.
//
@objc public class SurrogateCAAnimationDelegateSwift: NSObject {
    private typealias AnimationDidStartFunction = @convention(c) (AnyObject, Selector, CAAnimation?) -> Void
    private typealias AnimationDidFinishFunction = @convention(c) (AnyObject, Selector, CAAnimation?, Bool) -> Void
    
    @objc public static func animationDidStart(
        object: AnyObject,
        animation: CAAnimation?,
        isInvokedFromSwizzledMethod: Bool
    ) {
        animation?.mb_state = .started
        
        if isInvokedFromSwizzledMethod {
            let swizzledSelector = #selector(SurrogateCAAnimationDelegateObjC.mbswizzled_animationDidStart(_:))
            let originalImp = class_getMethodImplementation(type(of: object), swizzledSelector)
            
            let originalSelector = #selector(SurrogateCAAnimationDelegateObjC.animationDidStart(_:))
            let swizzledImp = class_getMethodImplementation(type(of: object), originalSelector)
            
            if swizzledImp == originalImp {
                // TODO: Fix this issue. Tapping alert leads to stack overflow.
                // IMPs shouldn't be same here.
            } else {
                unsafeBitCast(originalImp, to: AnimationDidStartFunction.self)(object, swizzledSelector, animation)
            }
        }
    }

    @objc public static func animationDidStop(
        object: AnyObject,
        animation: CAAnimation?,
        finished: Bool,
        isInvokedFromSwizzledMethod: Bool
    ) {
        animation?.mb_state = .stopped
        
        if isInvokedFromSwizzledMethod {
            let swizzledSelector = #selector(SurrogateCAAnimationDelegateObjC.mbswizzled_animationDidStop(_:finished:))
            let originalImp = class_getMethodImplementation(type(of: object), swizzledSelector)
            
            let originalSelector = #selector(SurrogateCAAnimationDelegateObjC.animationDidStop(_:finished:))
            let swizzledImp = class_getMethodImplementation(type(of: object), originalSelector)
            
            if swizzledImp == originalImp {
                // TODO: Fix this issue. Tapping alert leads to stack overflow.
                // IMPs shouldn't be same here.
            } else {
                unsafeBitCast(originalImp, to: AnimationDidFinishFunction.self)(object, swizzledSelector, animation, finished)
            }
        }
    }
}

#endif
