#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol AccessibilityEnhancer: AnyObject {
    func enhanceAccessibility() throws
}

#endif
