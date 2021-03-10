import XCTest

// Adds Xcode reports to StepLogger (View -> Navigators -> Show Report Navigator).
// They help to debug tests.
public final class XctActivityStepLogger: StepLogger {
    private let originalStepLogger: StepLogger
    private let xctAttachmentsAdder: XctAttachmentsAdder
    
    public init(
        originalStepLogger: StepLogger,
        xctAttachmentsAdder: XctAttachmentsAdder)
    {
        self.originalStepLogger = originalStepLogger
        self.xctAttachmentsAdder = xctAttachmentsAdder
    }
    
    public func logStep<T>(
        stepLogBefore: StepLogBefore,
        body: () -> StepLoggerResultWrapper<T>)
        -> StepLoggerResultWrapper<T>
    {
        return originalStepLogger.logStep(stepLogBefore: stepLogBefore) { [xctAttachmentsAdder] () -> StepLoggerResultWrapper<T> in
            // Xcode 11.3 stopped rendering multiline log entries properly.
            // Multiline entries are trimmed to a single line, text is centered in a fixed height cell.
            let activityTitle = stepLogBefore.title.replacingOccurrences(of: "\n", with: " ")
            return XCTContext.runActivity(named: activityTitle) { (activity: XCTActivity) -> StepLoggerResultWrapper<T> in
                xctAttachmentsAdder.add(attachments: stepLogBefore.attachments, activity: activity)
                
                let result = body()
                
                xctAttachmentsAdder.add(attachments: result.stepLogAfter.attachments, activity: activity)
                
                return result
            }
        }
    }
}
