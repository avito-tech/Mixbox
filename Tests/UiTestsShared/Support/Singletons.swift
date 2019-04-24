import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxArtifacts
import MixboxReporting
import MixboxAllure

// Singletons are necessary, because we have 2 entry points:
// - PrincipalClass (entry and exit of test bundle)
// - TestCase's (entry and exit of test methods)
//
// Do not add here anything that can be initialized in a single entry point.

final class Singletons {
    static let stepLogger: StepLogger = recodableStepLogger
    static let stepLogsProvider: StepLogsProvider = recodableStepLogger
    static let stepLoggerRecordingStarter: StepLoggerRecordingStarter = recodableStepLogger
    
    private static let recodableStepLogger = RecodableStepLogger(
        payloadLogger: StepLoggerImpl()
    )
}
