import MixboxTestsFoundation
import MixboxFoundation

typealias RetriableTimedInteractionState = IsPossibleToRetryProvider & MarkableAsImpossibleToRetry

final class RetriableTimedInteractionStateImpl: RetriableTimedInteractionState {
    // MARK: - Dependencies
    
    private let dateProvider: DateProvider
    private let timeout: TimeInterval
    private let startDateOfInteraction: Date
    
    // MARK: - State
    
    private var isMarkedAsImpossibleToRetry = false
    
    // MARK: - Init
    
    init(
        dateProvider: DateProvider,
        timeout: TimeInterval,
        startDateOfInteraction: Date)
    {
        self.dateProvider = dateProvider
        self.timeout = timeout
        self.startDateOfInteraction = startDateOfInteraction
    }
    
    // MARK: - IsPossibleToRetryProvider
    
    func isPossibleToRetry() -> Bool {
        return !isMarkedAsImpossibleToRetry && !interactionWasTimedOut()
    }
    
    // MARK: - MarkableAsImpossibleToRetry
    
    func markAsImpossibleToRetry() {
        isMarkedAsImpossibleToRetry = true
    }
    
    // MARK: - Private
    
    private func interactionWasTimedOut() -> Bool {
        return dateProvider.currentDate().timeIntervalSince(startDateOfInteraction) > timeout
    }
}
