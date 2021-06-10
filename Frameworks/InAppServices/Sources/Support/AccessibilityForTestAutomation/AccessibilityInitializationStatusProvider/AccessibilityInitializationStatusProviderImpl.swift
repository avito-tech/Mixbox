#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

public final class AccessibilityInitializationStatusProviderImpl: AccessibilityInitializationStatusProvider {
    private let testedObject = UIView()
    
    public init() {
    }
    
    public var accessibilityInitializationStatus: AccessibilityInitializationStatus {
        let accessibilityUserTestingChildrenSelectorName = "_accessibilityUserTestingChildren"
        let selectorThatIsOnlyAvailableIfAxIsSetUp = NSSelectorFromString(accessibilityUserTestingChildrenSelectorName)
        
        if testedObject.responds(to: selectorThatIsOnlyAvailableIfAxIsSetUp) {
            return .initialized
        } else {
            return .notInitialized
        }
    }
}

#endif
