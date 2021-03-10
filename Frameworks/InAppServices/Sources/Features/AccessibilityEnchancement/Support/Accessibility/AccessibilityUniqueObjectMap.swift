#if MIXBOX_ENABLE_IN_APP_SERVICES

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
