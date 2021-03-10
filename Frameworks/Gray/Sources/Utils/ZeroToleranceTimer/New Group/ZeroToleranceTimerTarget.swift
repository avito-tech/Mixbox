public final class ZeroToleranceTimerTarget {
    public let timerFired: () -> ()
    
    public init(timerFired: @escaping () -> ()) {
        self.timerFired = timerFired
    }
}
