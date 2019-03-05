import XCTest
import MixboxArtifacts
import MixboxReporting

// Adds Xcode reports to StepLogger (View -> Navigators -> Show Report Navigator).
// They help to debug tests.
public final class XcuiActivityStepLogger: StepLogger {
    private let originalStepLogger: StepLogger
    
    public init(originalStepLogger: StepLogger) {
        self.originalStepLogger = originalStepLogger
    }
    
    public func logStep<T>(
        stepLogBefore: StepLogBefore,
        body: () -> StepLoggerWrappedResult<T>)
        -> T
    {
        return originalStepLogger.logStep(stepLogBefore: stepLogBefore) { () -> StepLoggerWrappedResult<T> in
            let name = stepLogBefore.detailedDescription
            return XCTContext.runActivity(named: name) { (activity: XCTActivity) -> StepLoggerWrappedResult<T> in
                stepLogBefore.artifacts.forEach { addAttachment(artifact: $0, activity: activity) }
                
                let result = body()
                
                result.stepLogAfter.artifacts.forEach { addAttachment(artifact: $0, activity: activity) }
                
                return result
            }
        }
    }
    
    private func addAttachment(artifact: Artifact, activity: XCTActivity) {
        switch artifact.content {
        case .screenshot(let screenshot):
            activity.add(
                attachment: XCTAttachment(image: screenshot),
                name: artifact.name
            )
        case .text(let string):
            activity.add(
                attachment: XCTAttachment(string: string),
                name: artifact.name
            )
        case .json(let string):
            activity.add(
                attachment: XCTAttachment(string: string),
                name: artifact.name
            )
        case .artifacts(let artifacts):
            for artifact in artifacts {
                addAttachment(artifact: artifact, activity: activity)
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
