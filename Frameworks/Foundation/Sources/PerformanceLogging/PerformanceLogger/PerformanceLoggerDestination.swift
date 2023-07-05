#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

public enum PerformanceLoggerDestination: Int, Hashable {
    case signpost
    case graphite
    
    public static var allDestinations: Set<PerformanceLoggerDestination> {
        [.signpost, .graphite]
    }
    
    public static var signpostDestinations: Set<PerformanceLoggerDestination> {
        [.signpost]
    }
}

#endif
