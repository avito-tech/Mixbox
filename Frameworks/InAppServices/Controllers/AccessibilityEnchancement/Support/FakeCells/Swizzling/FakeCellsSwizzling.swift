// Facade for swizzling for supporting FakeCells.
final class FakeCellsSwizzling {
    static func swizzle(shouldAddAssertionForCallingIsHiddenOnFakeCell: Bool) {
        var allSwizzlingResults = CollectionViewSwizzler.swizzle()
            
        allSwizzlingResults.append(
            contentsOf: CollectionViewCellSwizzler.swizzle(
                shouldAddAssertionForCallingIsHiddenOnFakeCell: shouldAddAssertionForCallingIsHiddenOnFakeCell
            )
        )
        
        assertSwizzlingWasCorrect(swizzlingResults: allSwizzlingResults)
    }
    
    private static func assertSwizzlingWasCorrect(swizzlingResults: [FakeCellSwizzlingResult]) {
        var swizzledMethods = Set<Method>()
        
        for result in swizzlingResults {
            switch result {
            case .swizzledOriginalMethod(let method):
                if swizzledMethods.contains(method) {
                    assertionFailure("Method was swizzled twice! Rewrite swizzling."
                        + " You probalby need to share the implementation. Method: \(method)")
                } else {
                    swizzledMethods.insert(method)
                }
            case .failedToGetOriginalMethod(let type, let selector):
                assertionFailureForFailureInGettingMethod(type: type, selector: selector, methodAdjective: "original")
            case .failedToGetSwizzledMethod(let type, let selector):
                assertionFailureForFailureInGettingMethod(type: type, selector: selector, methodAdjective: "swizzled")
            }
        }
    }
    
    private static func assertionFailureForFailureInGettingMethod(
        type: NSObject.Type,
        selector: Selector,
        methodAdjective: String)
    {
        assertionFailure("Failed to get \(methodAdjective) method. Type: \(type). Selector: \(selector)")
    }
}
