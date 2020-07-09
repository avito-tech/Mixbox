#if MIXBOX_ENABLE_IN_APP_SERVICES

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
