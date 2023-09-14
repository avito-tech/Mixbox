import UIKit

public final class InteractionFailureResultFactoryImpl: InteractionFailureResultFactory {
    private let applicationStateProvider: ApplicationStateProvider
    private let messagePrefix: String
    private let interactionResultMaker: InteractionResultMaker
    
    public init(
        applicationStateProvider: ApplicationStateProvider,
        messagePrefix: String,
        interactionResultMaker: InteractionResultMaker)
    {
        self.applicationStateProvider = applicationStateProvider
        self.messagePrefix = messagePrefix
        self.interactionResultMaker = interactionResultMaker
    }
    
    public func elementIsHiddenResult()
        -> InteractionResult
    {
        return failureResult(
            message: "element is present in hierarchy, but is hidden"
        )
    }
    
    public func elementIsNotSufficientlyVisibleResult(
        percentageOfVisibleArea: CGFloat,
        minimalPercentageOfVisibleArea: CGFloat,
        potentialCauseOfFailure: String?)
        -> InteractionResult
    {
        let suffix = potentialCauseOfFailure.flatMap { message in
            ", which might (or might not) be caused by: \(message)"
        } ?? ""
        
        return failureResult(
            message:
            """
            element is not sufficiently visible \
            (actual percentage of visible area: \(percentageOfVisibleArea), \
            expected percentage of visible area: \(minimalPercentageOfVisibleArea))\(suffix)
            """
        )
    }
    
    public func elementIsNotFoundResult()
        -> InteractionResult
    {
        let applicationStateNotice: String
            
        do {
            let applicationState = try applicationStateProvider.applicationState()
            
            applicationStateNotice = applicationState == .runningForeground
                ? ""
                : ", this might be because application wasn't started or crashed (application state = \(applicationState))"
        } catch {
            applicationStateNotice = ", also an error occured while getting application state: \(error)"
        }
        
        return failureResult(
            message: "element was not found in hierarchy\(applicationStateNotice)"
        )
    }
    
    public func elementIsNotUniqueResult()
        -> InteractionResult
    {
        return failureResult(
            message: "expected unique element, but found multiple matching elements"
        )
    }
    
    public func failureResult(
        interactionFailure: InteractionFailure)
        -> InteractionResult
    {
        return interactionResultMaker.decorateFailure(interactionFailure: interactionFailure)
    }
}
