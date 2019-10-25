import XCTest
import MixboxTestsFoundation

// Adds Xcode reports to StepLogger (View -> Navigators -> Show Report Navigator).
// They help to debug tests.
public final class XcuiActivityStepLogger: StepLogger {
    private let originalStepLogger: StepLogger
    
    public init(originalStepLogger: StepLogger) {
        self.originalStepLogger = originalStepLogger
    }
    
    public func logStep<T>(
        stepLogBefore: StepLogBefore,
        body: () -> StepLoggerResultWrapper<T>)
        -> StepLoggerResultWrapper<T>
    {
        return originalStepLogger.logStep(stepLogBefore: stepLogBefore) { () -> StepLoggerResultWrapper<T> in
            XCTContext.runActivity(named: stepLogBefore.title) { (activity: XCTActivity) -> StepLoggerResultWrapper<T> in
                stepLogBefore.attachments.forEach { addAttachment(attachment: $0, activity: activity) }
                
                let result = body()
                
                result.stepLogAfter.attachments.forEach { addAttachment(attachment: $0, activity: activity) }
                
                return result
            }
        }
    }
    
    private func addAttachment(attachment: Attachment, activity: XCTActivity) {
        switch attachment.content {
        case .screenshot(let screenshot):
            activity.add(
                attachment: XCTAttachment(image: screenshot),
                name: attachment.name
            )
        case .text(let string):
            activity.add(
                attachment: XCTAttachment(string: string),
                name: attachment.name
            )
        case .json(let string):
            activity.add(
                attachment: XCTAttachment(string: string),
                name: attachment.name
            )
        case .attachments(let attachments):
            for attachment in attachments {
                addAttachment(attachment: attachment, activity: activity)
            }
        }
    }
}

private extension XCTActivity {
    func add(attachment: XCTAttachment, name: String) {
        attachment.name = name
        add(attachment)
    }
}
