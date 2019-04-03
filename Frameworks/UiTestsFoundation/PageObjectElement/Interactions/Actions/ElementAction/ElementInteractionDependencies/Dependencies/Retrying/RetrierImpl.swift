public final class RetrierImpl: Retrier {
    private let pollingConfiguration: PollingConfiguration
    
    public init(
        pollingConfiguration: PollingConfiguration)
    {
        self.pollingConfiguration = pollingConfiguration
    }
    
    public func retry<T>(
        firstAttempt: () -> T,
        everyNextAttempt: () -> T,
        shouldRetry: (T) -> Bool,
        isPossibleToRetryProvider: IsPossibleToRetryProvider)
        -> T
    {
        var result = firstAttempt()
        
        while isPossibleToRetryProvider.isPossibleToRetry(), shouldRetry(result) {
            waitRespectingPollingConfiguration()
            
            result = everyNextAttempt()
        }
        
        return result
    }
    
    private func waitRespectingPollingConfiguration() {
        if case .reduceWorkload = pollingConfiguration {
            Thread.sleep(forTimeInterval: 1)
            // Before Feb 2019: RunLoop.current.run(until: Date().addingTimeInterval(1.0))
        }
    }
}
