import MixboxTestsFoundation

final class RecordingStepLoggerImpl: StepLogger, StepLogsProvider, StepLogsCleaner, StartedStepLoggerRecording {
    private let stepLogger = StepLoggerImpl()
    private let stopRecordingClosure: (RecordingStepLoggerImpl) -> ()
    
    init(stopRecordingClosure: @escaping (RecordingStepLoggerImpl) -> ()) {
        self.stopRecordingClosure = stopRecordingClosure
    }
    
    deinit {
        stopRecording()
    }
    
    // MARK: - StepLogger
    
    func logStep<T>(
        stepLogBefore: StepLogBefore,
        body: () -> StepLoggerResultWrapper<T>)
        -> StepLoggerResultWrapper<T>
    {
        return stepLogger.logStep(
            stepLogBefore: stepLogBefore,
            body: body
        )
    }
    
    // MARK: - StepLogsProvider
    
    var stepLogs: [StepLog] {
        return stepLogger.stepLogs
    }
    
    // MARK: - StepLogsCleaner
    
    func cleanLogs() {
        stepLogger.cleanLogs()
    }
    
    // MARK: - StartedStepLoggerRecording
    
    func stopRecording() {
        stopRecordingClosure(self)
    }
}
