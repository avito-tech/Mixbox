#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import Foundation
import MixboxFoundation
import MixboxTestability

final class AccessibilityUniqueObjectMap {
    static let shared = AccessibilityUniqueObjectMap()
    
    private init() {}
    private var weaklyBoxedElements = [String: WeakBox<TestabilityElement>]()
    
    func register(element: TestabilityElement) {
        weaklyBoxedElements[element.mb_testability_uniqueIdentifier()] = WeakBox(element)
    }
    
    func locate(uniqueIdentifier: String) -> TestabilityElement? {
        return weaklyBoxedElements[uniqueIdentifier]?.value
    }
}

#endif
