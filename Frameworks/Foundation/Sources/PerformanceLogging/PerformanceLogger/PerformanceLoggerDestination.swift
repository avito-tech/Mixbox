#if MIXBOX_ENABLE_IN_APP_SERVICES

public enum PerformanceLoggerDestination: Int, Hashable {
    case signpost
    case graphite
    
    public static let allDestinations: Set<PerformanceLoggerDestination> = [.signpost, .graphite]
    public static let signpostDestinations: Set<PerformanceLoggerDestination> = [.signpost]
}

#endif
