public final class SwizzlingSyncronizationImpl: SwizzlingSyncronization {
    private var swizzledMethods = Set<Method>()
    
    public init() {
    }
    
    public func append(swizzlingResult: SwizzlingResult) -> ErrorString? {
        switch swizzlingResult {
        case .swizzledOriginalMethod(let method):
            if swizzledMethods.contains(method) {
                return ErrorString(
                    "Method was swizzled twice! Rewrite swizzling."
                        + " You probalby need to share the implementation. Method: \(method)"
                )
            } else {
                swizzledMethods.insert(method)
                return nil
            }
        case .failedToGetOriginalMethod(let type, let selector):
            return assertionFailureMessageForFailureInGettingMethod(
                type: type,
                selector: selector,
                methodAdjective: "original"
            )
        case .failedToGetSwizzledMethod(let type, let selector):
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
