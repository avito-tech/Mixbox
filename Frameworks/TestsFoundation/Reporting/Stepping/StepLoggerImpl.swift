public final class StepLoggerImpl: StepLogger, StepLogsProvider, StepLogsCleaner {
    private var stepper = Stepper<StepLogBefore, StepLogAfter>()
    
    public init() {
    }
    
    // MARK: - StepLogsProvider
    
    public var stepLogs: [StepLog] {
        return stepper.steps(
            combineFunction: { (before: StepLogBefore, after: StepLogAfter?, children: [StepLog]) in
                StepLog(
                    before: before,
                    after: after,
                    steps: children
                )
            }
        )
    }
    
    // MARK: - StepLogsCleaner
    
    public func cleanLogs() {
        stepper = Stepper<StepLogBefore, StepLogAfter>()
    }
    
    // MARK: - StepLogger
    
    public func logStep<T>(
        stepLogBefore: StepLogBefore,
        body: () -> StepLoggerResultWrapper<T>)
        -> StepLoggerResultWrapper<T>
    {
        return stepper.step(beforeResult: stepLogBefore) {
            let result = body()
            
            return Stepper.WrappedResultWithAfterResult(
                afterResult: result.stepLogAfter,
                wrappedResult: result
            )
        }
    }
}
