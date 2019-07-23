#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class SwizzlingSynchronizationImpl: SwizzlingSynchronization {
    private var swizzledMethods = Set<Method>()
    
    public init() {
    }
    
    public func append(
        swizzlingResult: SwizzlingResult,
        shouldAssertIfMethodIsSwizzledOnlyOneTime: Bool)
        -> ErrorString?
    {
        let result: ErrorString?
        
        switch swizzlingResult {
        case let .swizzledOriginalMethod(method):
            if swizzledMethods.contains(method) {
                if shouldAssertIfMethodIsSwizzledOnlyOneTime {
                    let selector = method_getName(method)
                    result = ErrorString(
                        "Method was swizzled twice! Rewrite swizzling."
                            + " You probably need to share the implementation. Selector: \(selector)"
                    )
                } else {
                    result = nil
                }
            } else {
                swizzledMethods.insert(method)
                result = nil
            }
        case let .failedToGetOriginalMethod(type, selector):
            result = assertionFailureMessageForFailureInGettingMethod(
                type: type,
                selector: selector,
                methodAdjective: "original"
            )
        case let .failedToGetSwizzledMethod(type, selector):
            result = assertionFailureMessageForFailureInGettingMethod(
                type: type,
                selector: selector,
                methodAdjective: "swizzled"
            )
        }
        
        return result
    }
    
    private func assertionFailureMessageForFailureInGettingMethod(
        type: NSObject.Type,
        selector: Selector,
        methodAdjective: String)
        -> ErrorString
    {
        return ErrorString("Failed to get \(methodAdjective) method. Type: \(type). Selector: \(selector)")
    }
}

#endif
