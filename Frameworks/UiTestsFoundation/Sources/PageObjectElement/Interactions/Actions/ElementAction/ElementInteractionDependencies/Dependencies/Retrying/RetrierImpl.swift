import MixboxTestsFoundation
import MixboxFoundation

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
        firstAttempt: () throws -> T,
        everyNextAttempt: () throws -> T,
        shouldRetry: (T) throws -> Bool,
        isPossibleToRetryProvider: IsPossibleToRetryProvider)
        rethrows
        -> T
    {
        var result = try firstAttempt()
     
        while isPossibleToRetryProvider.isPossibleToRetry(), try shouldRetry(result) {
            waitRespectingPollingConfiguration()
            
            result = try everyNextAttempt()
        }
        
        return result
    }
    
    private func waitRespectingPollingConfiguration() {
        if case .reduceWorkload = pollingConfiguration {
            // TODO: Implement retrying using Waiter functionality.
            waiter.wait(timeout: 1)
        }
    }
}
