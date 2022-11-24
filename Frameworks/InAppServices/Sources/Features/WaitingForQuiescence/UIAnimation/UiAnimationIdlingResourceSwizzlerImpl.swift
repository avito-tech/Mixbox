#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxFoundation

public class UiAnimationIdlingResourceSwizzlerImpl: NSObject, UiAnimationIdlingResourceSwizzler {
    public let assertingSwizzler: AssertingSwizzler
    public let assertionFailureRecorder: AssertionFailureRecorder
    
    public init(
        assertingSwizzler: AssertingSwizzler,
        assertionFailureRecorder: AssertionFailureRecorder) {
        self.assertingSwizzler = assertingSwizzler
        self.assertionFailureRecorder = assertionFailureRecorder
    }
    
    public func swizzle() {
        swizzle(
            originalSelector: markStartSelector,
            swizzledSelector: #selector(swizzled_markStart(startTime:))
        )
        swizzle(
            originalSelector: markStopSelector,
            swizzledSelector: #selector(swizzled_markStop)
        )
    }
    
    private func swizzle(
        originalSelector: Selector,
        swizzledSelector: Selector)
    {
        guard let uiAnimationClass = NSClassFromString("UIAnimation") as? NSObject.Type else {
            assertionFailureRecorder.recordAssertionFailure(
                message: "Class UIAnimation not found"
            )
            return
        }
        assertingSwizzler.swizzle(
            originalClass: uiAnimationClass,
            swizzlingClass: UiAnimationIdlingResourceSwizzlerImpl.self,
            originalSelector: originalSelector,
            swizzledSelector: swizzledSelector,
            methodType: .instanceMethod,
            shouldAssertIfMethodIsSwizzledOnlyOneTime: true
        )
    }
    
    /**
     self will resolve to UIAnimation even though UIAnimationIdlingResourceSwizzlerImpl is not an extension of UIAnimation
    */
    fileprivate var trackedAnimation: AssociatedObject<TrackedIdlingResource> {
        return AssociatedObject(
            container: self,
            key: "UIAnimationIdlingResourceSwizzlerImpl_trackedAnimation"
        )
    }

    /**
     Swizzled out implementation of the UIAnimation methods will be located in the appropriate methods of
     UIAnimationIdlingResourceSwizzlerImpl. Calling the method directly will resolve to swizzled in implementation
     but by calling class_getMethodImplementation one can fetch the swizzled out implementation.
     */
    private typealias MarkStartFunction = @convention(c) (AnyObject, Selector, TimeInterval) -> Void
    private var markStartSelector: Selector { return Selector(privateName: "markStart:") }
    @objc fileprivate func swizzled_markStart(startTime: TimeInterval) {
        trackedAnimation.value = IdlingResourceObjectTracker.instance.track(parent: self)
        
        let originalImp = class_getMethodImplementation(UiAnimationIdlingResourceSwizzlerImpl.self, #selector(swizzled_markStart))
        unsafeBitCast(originalImp, to: MarkStartFunction.self)(self, markStartSelector, startTime)
    }

    private typealias MarkStopFunction = @convention(c) (AnyObject, Selector) -> Void
    private var markStopSelector: Selector { return Selector(privateName: "markStop") }
    @objc fileprivate func swizzled_markStop() {
        trackedAnimation.value?.untrack()

        let originalImp = class_getMethodImplementation(UiAnimationIdlingResourceSwizzlerImpl.self, #selector(swizzled_markStop))
        unsafeBitCast(originalImp, to: MarkStopFunction.self)(self, markStopSelector)
    }

}

#endif
