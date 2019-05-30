import MixboxReporting

protocol StartedStepLoggerRecording: class, StepLogger, StepLogsProvider {
    func stopRecording()
}
