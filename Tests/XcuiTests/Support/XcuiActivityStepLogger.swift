import XCTest
import MixboxTestsFoundation
import MixboxArtifacts
import MixboxReporting

// TODO: Share with Avito
// Добавляет к StepLogger еще отчеты в Xcode IDE (слева, show the report navigator).
// Они могут помочь посмотреть ход выполнения теста при разработке.
final class XcuiActivityStepLogger: StepLogger {
    private let originalStepLogger: StepLogger
    
    init(originalStepLogger: StepLogger) {
        self.originalStepLogger = originalStepLogger
    }
    
    func logStep<T>(
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
