public final class SwizzlingSyncronizationImpl: SwizzlingSyncronization {
    private var swizzledMethods = Set<Method>()
    
    public init() {
    }
    
    public func append(swizzlingResult: SwizzlingResult) -> ErrorString? {
        switch swizzlingResult {
        case let .swizzledOriginalMethod(method):
            if swizzledMethods.contains(method) {
                let selector = method_getName(method)
                return ErrorString(
                    "Method was swizzled twice! Rewrite swizzling."
                        + " You probalby need to share the implementation. Selector: \(selector)"
                )
            } else {
                swizzledMethods.insert(method)
                return nil
            }
        case let .failedToGetOriginalMethod(type, selector):
            return assertionFailureMessageForFailureInGettingMethod(
                type: type,
                selector: selector,
                methodAdjective: "original"
            )
        case let .failedToGetSwizzledMethod(type, selector):
            return assertionFailureMessageForFailureInGettingMethod(
                type: type,
                selector: selector,
                methodAdjective: "swizzled"
            )
        }
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
