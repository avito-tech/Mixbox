import MixboxTestsFoundation
import MixboxUiTestsFoundation

// TODO: Make generic and rename?
final class InteractionRetrierImpl: InteractionRetrier {
    private let dateProvider: DateProvider
    private let timeout: TimeInterval
    private let retrier: Retrier
    
    init(
        dateProvider: DateProvider,
        timeout: TimeInterval,
        retrier: Retrier)
    {
        self.dateProvider = dateProvider
        self.timeout = timeout
        self.retrier = retrier
    }
    
    func retryInteractionUntilTimeout(
        closure: (_ interaction: RetriableTimedInteractionState) -> InteractionResult)
        -> InteractionResult
    {
        let retriableTimedInteractionState = RetriableTimedInteractionStateImpl(
            dateProvider: dateProvider,
            timeout: timeout,
            startDateOfInteraction: dateProvider.currentDate()
        )
        
        return retrier.retry(
            attempt: {
                closure(retriableTimedInteractionState)
            },
            shouldRetry: { result in
                if case .failure = result {
                    return true
                } else {
                    return false
                }
            },
            isPossibleToRetryProvider: retriableTimedInteractionState
        )
    }
}
