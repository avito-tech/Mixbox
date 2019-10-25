import MixboxTestsFoundation

protocol StartedStepLoggerRecording: StepLogger, StepLogsProvider {
    func stopRecording()
}
