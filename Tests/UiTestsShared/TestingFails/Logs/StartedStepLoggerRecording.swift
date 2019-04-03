import MixboxReporting

protocol StartedStepLoggerRecording: StepLogger, StepLogsProvider {
    func stopRecording()
}
