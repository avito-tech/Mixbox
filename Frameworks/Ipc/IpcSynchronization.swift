#if MIXBOX_ENABLE_IN_APP_SERVICES

// This class violates OOP/SOLID in many ways.
// We want tests to be synchronous, it makes writing them easier.
//
// TODO: Rewrite.
public final class IpcSynchronization {
    public static func waitWhile(_ condition: () -> Bool) {
        // TODO: Use a specific tool for non-blocking (kind of) waiting in the current thread.
        var delayIntervals = [0.05, 0.1, 0.2, 0.4, 1, 5]
        
        while condition() {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: delayIntervals[0]))
            if delayIntervals.count > 1 {
                delayIntervals = Array(delayIntervals.dropFirst())
            }
        }
    }
}

#endif
