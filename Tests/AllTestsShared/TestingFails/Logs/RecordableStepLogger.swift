import MixboxTestsFoundation
import MixboxFoundation

final class RecordableStepLogger: StepLogger, StepLogsProvider, StepLoggerRecordingStarter, StepLogsCleaner {
    private let payloadLogger: StepLogger & StepLogsProvider & StepLogsCleaner
    private var recordingLoggers = [WeakBox<RecordingStepLoggerImpl>]()
    
    init(payloadLogger: StepLogger & StepLogsProvider & StepLogsCleaner) {
        self.payloadLogger = payloadLogger
    }
    
    func startRecording() -> StartedStepLoggerRecording & StepLogsProvider {
        let logger = RecordingStepLoggerImpl(
            stopRecordingClosure: { [weak self] stepLogger in
                self?.recordingLoggers.removeAll { weakBox in
                    if let recordingLogger = weakBox.value {
                        return recordingLogger === stepLogger
                    } else {
                        return true
                    }
                }
            }
        )
        
        recordingLoggers.append(WeakBox(logger))
        
        return logger
    }
    
    var stepLogs: [StepLog] {
        return payloadLogger.stepLogs
    }
    
    func cleanLogs() {
        let loggers: [StepLogger & StepLogsProvider & StepLogsCleaner] = [payloadLogger] + recordingLoggers.compactMap { $0.value }
        loggers.forEach {
            $0.cleanLogs()
        }
    }

    func logStep<T>(
        stepLogBefore: StepLogBefore,
        body: () -> StepLoggerResultWrapper<T>)
        -> StepLoggerResultWrapper<T>
    {
        return recursiveLog(
            stepLogBefore: stepLogBefore,
            body: body,
            loggers: recordingLoggers.compactMap { $0.value }
        )
    }
    
    private func recursiveLog<T>(
        stepLogBefore: StepLogBefore,
        body: () -> StepLoggerResultWrapper<T>,
        loggers: [StepLogger])
        -> StepLoggerResultWrapper<T>
    {
        // Simplified version of what is happening:
        //
        //  log {
        //      log {
        //          log { // <- this is payloadLogger
        //              body()
        //          }
        //      }
        //  }
        
        if let logger = loggers.first {
            let nestedLoggers = Array(loggers.dropFirst())
            
            return logger.logStep(
                stepLogBefore: stepLogBefore,
                body: {
                    recursiveLog(
                        stepLogBefore: stepLogBefore,
                        body: body,
                        loggers: nestedLoggers
                    )
                }
            )
        } else {
            return payloadLogger.logStep(
                stepLogBefore: stepLogBefore,
                body: body
            )
        }
    }
}
