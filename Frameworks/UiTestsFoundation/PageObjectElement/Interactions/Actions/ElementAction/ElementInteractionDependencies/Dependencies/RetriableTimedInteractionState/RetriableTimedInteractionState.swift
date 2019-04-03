import MixboxTestsFoundation
import MixboxFoundation

public typealias RetriableTimedInteractionState = IsPossibleToRetryProvider & MarkableAsImpossibleToRetry

public final class RetriableTimedInteractionStateImpl: RetriableTimedInteractionState {
    // MARK: - Dependencies

    private let dateProvider: DateProvider
    private let timeout: TimeInterval
    private let startDateOfInteraction: Date
    
    // MARK: - State
    
    private var isMarkedAsImpossibleToRetry = false
    
    // MARK: - Init
    
    public init(
        dateProvider: DateProvider,
        timeout: TimeInterval,
        startDateOfInteraction: Date)
    {
        self.dateProvider = dateProvider
        self.timeout = timeout
        self.startDateOfInteraction = startDateOfInteraction
    }
    
    // MARK: - IsPossibleToRetryProvider
    
    public func isPossibleToRetry() -> Bool {
        return !isMarkedAsImpossibleToRetry && !interactionWasTimedOut()
    }
    
    // MARK: - MarkableAsImpossibleToRetry
    
    public func markAsImpossibleToRetry() {
        isMarkedAsImpossibleToRetry = true
    }
    
    // MARK: - Private
    
    private func interactionWasTimedOut() -> Bool {
        return dateProvider.currentDate().timeIntervalSince(startDateOfInteraction) > timeout
    }
}
