#if MIXBOX_ENABLE_IN_APP_SERVICES

public enum AccessibilityInitializationStatus {
    case initialized
    case notInitialized
    
    public var isInitialized: Bool {
        switch self {
        case .initialized:
            return true
        case .notInitialized:
            return false
        }
    }
}

#endif
