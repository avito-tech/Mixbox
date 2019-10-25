import MixboxTestsFoundation

protocol StepLoggerRecordingStarter: class {
    func startRecording() -> StartedStepLoggerRecording & StepLogsProvider
}
