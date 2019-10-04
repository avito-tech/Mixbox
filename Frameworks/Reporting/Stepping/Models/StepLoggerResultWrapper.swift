public final class StepLoggerResultWrapper<T> {
    public let stepLogAfter: StepLogAfter
    public let wrappedResult: T
    
    public init(
        stepLogAfter: StepLogAfter,
        wrappedResult: T)
    {
        self.stepLogAfter = stepLogAfter
        self.wrappedResult = wrappedResult
    }
}
