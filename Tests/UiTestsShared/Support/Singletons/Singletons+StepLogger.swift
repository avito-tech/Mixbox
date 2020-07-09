import MixboxFoundation
import MixboxTestsFoundation
import MixboxUiTestsFoundation

extension Singletons {
    static let stepLogger: StepLogger = recordableStepLogger
    static let stepLogsProvider: StepLogsProvider = recordableStepLogger
    static let stepLoggerRecordingStarter: StepLoggerRecordingStarter = recordableStepLogger
    static let stepLogsCleaner: StepLogsCleaner = recordableStepLogger
    
    private static let recordableStepLogger = RecordableStepLogger(
        payloadLogger: StepLoggerImpl()
    )
    
    // Usage of XCTActivity crashes fbxctest, so we have to not use it.
    // TODO: Remove or rename to xctActivityLoggingIsEnabled.
    static var enableXctActivityLogging: Bool {
        // TODO: Get rid of usage of ProcessInfo singleton and also of this bool.
        return ProcessInfo.processInfo.environment["MIXBOX_CI_USES_FBXCTEST"] != "true"
    }
}
