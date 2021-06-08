import MixboxTestsFoundation

protocol StepLoggerRecordingStarter: AnyObject {
    func startRecording() -> StartedStepLoggerRecording & StepLogsProvider
}
