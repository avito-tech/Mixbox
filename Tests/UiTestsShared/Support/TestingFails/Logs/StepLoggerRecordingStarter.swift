import MixboxReporting

protocol StepLoggerRecordingStarter: class {
    func startRecording() -> StartedStepLoggerRecording & StepLogsProvider
}
