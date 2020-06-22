import UIKit
import Foundation

public final class ScheduledZeroToleranceTimerImpl: ScheduledZeroToleranceTimer {
    private let timer: DispatchSourceTimer
    private let activityId: NSObjectProtocol
    private var invalidated = false
    
    public init(
        scheduleZeroToleranceDispatchSourceTimer: DispatchSourceTimer,
        activityId: NSObjectProtocol)
    {
        self.timer = scheduleZeroToleranceDispatchSourceTimer
        self.activityId = activityId
    }
    
    public func invalidate() {
        if !invalidated {
            timer.cancel()
            ProcessInfo.processInfo.endActivity(activityId)
            invalidated = true
        }
    }
    
    deinit {
        invalidate()
    }
}
