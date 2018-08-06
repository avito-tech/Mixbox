public final class StepLoggerImpl: StepLogger, StepLogsProvider {
    private var stepper = Stepper<StepLogBefore, StepLogAfter>()
    
    public init() {
    }
    
    // MARK: - StepLogsProvider
    
    public var stepLogs: [StepLog] {
        return stepper.steps(
            combineFunction: { (before: StepLogBefore, after: StepLogAfter?, children: [StepLog]) in
                StepLog(
                    identifyingDescription: before.identifyingDescription,
                    detailedDescription: before.detailedDescription,
                    stepType: before.stepType,
                    startDate: before.date,
                    stopDate: after?.date,
                    wasSuccessful: after?.wasSuccessful ?? false,
                    artifactsBefore: before.artifacts,
                    artifactsAfter: after?.artifacts ?? [],
                    steps: children
                )
            }
        )
    }
    
    public func cleanLogs() {
        stepper = Stepper<StepLogBefore, StepLogAfter>()
    }
    
    // MARK: - StepLogger
    
    public func logStep<T>(
        stepLogBefore: StepLogBefore,
        body: () -> StepLoggerWrappedResult<T>)
        -> T
    {
        return stepper.step(beforeResult: stepLogBefore) {
            let result = body()
            
            return Stepper.WrappedResultWithAfterResult(
                afterResult: result.stepLogAfter,
                wrappedResult: result.wrappedResult
            )
        }
    }
    
    // MARK: -
}
