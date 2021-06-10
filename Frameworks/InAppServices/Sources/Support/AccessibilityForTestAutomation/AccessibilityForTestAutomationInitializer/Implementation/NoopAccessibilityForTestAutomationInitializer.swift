#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class NoopAccessibilityForTestAutomationInitializer: AccessibilityForTestAutomationInitializer {
    public init() {
    }
    
    public func initializeAccessibility() throws {
    }
}

#endif
