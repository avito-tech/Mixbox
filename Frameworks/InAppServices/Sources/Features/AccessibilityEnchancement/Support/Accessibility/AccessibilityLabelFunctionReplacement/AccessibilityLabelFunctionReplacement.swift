#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol AccessibilityLabelFunctionReplacement {
    func accessibilityLabel(
        this: NSObject?,
        originalImplementation: () -> NSString?)
        -> NSString?
}

#endif
