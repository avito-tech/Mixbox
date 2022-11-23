#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

public final class CompoundMeasureableTimedActivity: MeasureableTimedActivity {
    private let activities: [MeasureableTimedActivity]
    
    public init(activities: [MeasureableTimedActivity]) {
        self.activities = activities
    }
    
    public func stop() {
        activities.forEach { $0.stop() }
    }
}

#endif
