#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

public final class AssertingSwizzlerImpl: AssertingSwizzler {
    private let swizzler: Swizzler
    private let swizzlingSynchronization: SwizzlingSynchronization
    private let assertionFailureRecorder: AssertionFailureRecorder
    
    public init(
        swizzler: Swizzler,
        swizzlingSynchronization: SwizzlingSynchronization,
        assertionFailureRecorder: AssertionFailureRecorder)
    {
        self.swizzler = swizzler
        self.swizzlingSynchronization = swizzlingSynchronization
        self.assertionFailureRecorder = assertionFailureRecorder
    }
    
    public func swizzle(
        originalClass: NSObject.Type,
        swizzlingClass: NSObject.Type,
        originalSelector: Selector,
        swizzledSelector: Selector,
        methodType: MethodType,
        shouldAssertIfMethodIsSwizzledOnlyOneTime: Bool,
        fileLine: FileLine)
    {
        let swizzlingResult = swizzler.swizzle(originalClass, swizzlingClass, originalSelector, swizzledSelector, methodType)
        
        let errorOrNil = swizzlingSynchronization.append(
            swizzlingResult: swizzlingResult,
            shouldAssertIfMethodIsSwizzledOnlyOneTime: shouldAssertIfMethodIsSwizzledOnlyOneTime
        )
        
        if let error = errorOrNil {
            assertionFailureRecorder.recordAssertionFailure(
                message: error.value,
                fileLine: fileLine
            )
        }
    }
}

#endif
