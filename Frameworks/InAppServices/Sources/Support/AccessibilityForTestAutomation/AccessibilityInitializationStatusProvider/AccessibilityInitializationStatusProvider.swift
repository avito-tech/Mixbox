#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol AccessibilityInitializationStatusProvider {
    var accessibilityInitializationStatus: AccessibilityInitializationStatus { get }
}

#endif
