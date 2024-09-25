import Foundation
import MixboxTestsFoundation
import MixboxFoundation

public final class RetriableTimedInteractionStateImpl: RetriableTimedInteractionState {
    // MARK: - Dependencies

    private let dateProvider: DateProvider
    private let timeout: TimeInterval
    private let startDateOfInteraction: Date
    private let parent: RetriableTimedInteractionState?
    
    // MARK: - State
    
    private var isMarkedAsImpossibleToRetry = false
    
    // MARK: - Init
    
    public init(
        dateProvider: DateProvider,
        timeout: TimeInterval,
        startDateOfInteraction: Date,
        parent: RetriableTimedInteractionState?)
    {
        self.dateProvider = dateProvider
        self.timeout = timeout
        self.startDateOfInteraction = startDateOfInteraction
        self.parent = parent
    }
    
    // MARK: - IsPossibleToRetryProvider
    
    public func isPossibleToRetry() -> Bool {
        return !isMarkedAsImpossibleToRetry && !interactionWasTimedOut()
    }
    
    // MARK: - MarkableAsImpossibleToRetry
    
    public func markAsImpossibleToRetry() {
        isMarkedAsImpossibleToRetry = true
        parent?.markAsImpossibleToRetry()
    }
    
    // MARK: - RetriableTimedInteractionStateForNestedRetryOperationProvider
    
    public func retriableTimedInteractionStateForNestedRetryOperation() -> RetriableTimedInteractionState {
        return RetriableTimedInteractionStateImpl(
            dateProvider: dateProvider,
            timeout: timeout,
            startDateOfInteraction: startDateOfInteraction,
            parent: self
        )
    }
    
    // MARK: - Private
    
    private func interactionWasTimedOut() -> Bool {
        return dateProvider.currentDate().timeIntervalSince(startDateOfInteraction) > timeout
    }
}
