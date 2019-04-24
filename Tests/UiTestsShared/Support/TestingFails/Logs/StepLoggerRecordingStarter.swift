import MixboxReporting

protocol StepLoggerRecordingStarter {
    func startRecording() -> StartedStepLoggerRecording & StepLogsProvider
}
