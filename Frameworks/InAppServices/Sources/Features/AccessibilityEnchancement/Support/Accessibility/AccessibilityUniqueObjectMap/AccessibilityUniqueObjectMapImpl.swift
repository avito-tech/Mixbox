#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import Foundation
import MixboxFoundation
import MixboxTestability

// TODO: Rename. It has nothing to do with accessibility.
public final class AccessibilityUniqueObjectMapImpl: AccessibilityUniqueObjectMap {
    // TODO: Remove singleton.
    //       Properly share DI between MixboxInAppServices and MixboxGray, so they use same instances.
    public static let shared: AccessibilityUniqueObjectMap = AccessibilityUniqueObjectMapImpl()
    
    private var weaklyBoxedElements = [String: WeakBox<TestabilityElement>]()
    
    public init() {
    }
    
    public func register(element: TestabilityElement) {
        weaklyBoxedElements[element.mb_testability_uniqueIdentifier()] = WeakBox(element)
    }
    
    public func locate(uniqueIdentifier: String) -> TestabilityElement? {
        return weaklyBoxedElements[uniqueIdentifier]?.value
    }
}

#endif
