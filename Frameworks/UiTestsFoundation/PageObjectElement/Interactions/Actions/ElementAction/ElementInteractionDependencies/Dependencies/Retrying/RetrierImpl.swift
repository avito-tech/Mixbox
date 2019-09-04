import MixboxTestsFoundation

public final class RetrierImpl: Retrier {
    private let pollingConfiguration: PollingConfiguration
    private let waiter: RunLoopSpinningWaiter
    
    public init(
        pollingConfiguration: PollingConfiguration,
        waiter: RunLoopSpinningWaiter)
    {
        self.pollingConfiguration = pollingConfiguration
        self.waiter = waiter
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
            // TODO: Implement retrying using Waiter functionality.
            waiter.wait(timeout: 1)
            // Before May 2019: Thread.sleep(forTimeInterval: 1)
            // Before Feb 2019: RunLoop.current.run(until: Date().addingTimeInterval(1.0))
        }
    }
}
