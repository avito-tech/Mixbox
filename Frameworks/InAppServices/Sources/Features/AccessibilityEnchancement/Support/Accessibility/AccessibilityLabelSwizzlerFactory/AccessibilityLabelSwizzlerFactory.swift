#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol AccessibilityLabelSwizzlerFactory: class {
    func accessibilityLabelSwizzler() throws -> AccessibilityLabelSwizzler
}

#endif
