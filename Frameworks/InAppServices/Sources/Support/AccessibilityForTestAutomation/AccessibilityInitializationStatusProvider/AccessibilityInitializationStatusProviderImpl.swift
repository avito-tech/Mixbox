#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

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
