import MixboxTestsFoundation
import MixboxUiTestsFoundation

// Singletons are necessary, because we have 2 entry points:
// - PrincipalClass (entry and exit of test bundle)
// - TestCase's (entry and exit of test methods)
//
// Do not add here anything that can be initialized in a single entry point.

final class Singletons {
    static let stepLogger: StepLogger = recordableStepLogger
    static let stepLogsProvider: StepLogsProvider = recordableStepLogger
    static let stepLoggerRecordingStarter: StepLoggerRecordingStarter = recordableStepLogger
    static let stepLogsCleaner: StepLogsCleaner = recordableStepLogger
    
    private static let recordableStepLogger = RecordableStepLogger(
        payloadLogger: StepLoggerImpl()
    )

    // Usage of XCTActivity crashes fbxctest, so we have to not use it.
    static var enableXctActivityLogging: Bool {
        // TODO: Get rid of usage of ProcessInfo singleton and also of this bool.
        return ProcessInfo.processInfo.environment["MIXBOX_CI_USES_FBXCTEST"] != "true"
    }
}
