import MixboxTestsFoundation
import Foundation
import UIKit

public final class InteractionRetrierImpl: InteractionRetrier {
    private let dateProvider: DateProvider
    private let timeout: TimeInterval
    private let retrier: Retrier
    private let retriableTimedInteractionState: RetriableTimedInteractionState
    
    public init(
        dateProvider: DateProvider,
        timeout: TimeInterval,
        retrier: Retrier,
        retriableTimedInteractionState: RetriableTimedInteractionState)
    {
        self.dateProvider = dateProvider
        self.timeout = timeout
        self.retrier = retrier
        self.retriableTimedInteractionState = retriableTimedInteractionState
    }
    
    public func retryInteractionUntilTimeout(
        closure: (_ interaction: RetriableTimedInteractionState) -> InteractionResult)
        -> InteractionResult
    {
        let retriableTimedInteractionState = self.retriableTimedInteractionState
            .retriableTimedInteractionStateForNestedRetryOperation()
        
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
