#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol AccessibilityLabelSwizzlerFactory: AnyObject {
    func accessibilityLabelSwizzler() throws -> AccessibilityLabelSwizzler
}

#endif
