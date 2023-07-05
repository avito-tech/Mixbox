#if MIXBOX_ENABLE_FRAMEWORK_TESTABILITY && MIXBOX_DISABLE_FRAMEWORK_TESTABILITY
#error("Testability is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_TESTABILITY || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_TESTABILITY)
// The compilation is disabled
#else

import Foundation

public final class TestabilityElementFromAnyConverter {
    private init() {
    }
    
    // TODO: Test with: NSObject, non-NSObject, UIView, UIAccessibilityContainer.
    public static func testabilityElement(anyElement: Any) -> TestabilityElement {
        if let testabilityElement = anyElement as? TestabilityElement {
            return testabilityElement
        } else {
            // TODO: Log error (e.g. forward to tests).
            assertionFailure("Unknown accessibility element type: \(type(of: anyElement)), description of object: \(anyElement)")
            
            return NonTestabilityElementFallbackTestabilityElement(
                anyElement: anyElement
            )
        }
    }
}

#endif
