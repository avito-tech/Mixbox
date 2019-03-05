import MixboxUiTestsFoundation

final class InteractionFailureResultFactoryImpl: InteractionFailureResultFactory {
    private let applicationProvider: ApplicationProvider
    private let messagePrefix: String
    private let interactionName: String
    
    init(
        applicationProvider: ApplicationProvider,
        messagePrefix: String,
        interactionName: String)
    {
        self.applicationProvider = applicationProvider
        self.messagePrefix = messagePrefix
        self.interactionName = interactionName
    }
    
    func elementIsHiddenResult()
        -> InteractionResult
    {
        return failureResult(
            resolvedElementQuery: nil,
            interactionSpecificFailure: nil,
            message: "элемент есть в иерархии, но спрятан"
        )
    }
    
    func elementIsNotSufficientlyVisibleResult(
        percentageOfVisibleArea: CGFloat,
        minimalPercentageOfVisibleArea: CGFloat,
        scrollingFailureMessage: String?)
        -> InteractionResult
    {
        let suffix = scrollingFailureMessage.flatMap { message in
            ", на это могла повлиять ошибка при скроллинге: \(message)"
        }
        
        return failureResult(
            resolvedElementQuery: nil,
            interactionSpecificFailure: nil,
            message: "элемент не полностью видим"
                + " (видимая площадь: \(percentageOfVisibleArea),"
                + " ожидалось: \(minimalPercentageOfVisibleArea))"
                + (suffix ?? "")
        )
    }
    
    func elementIsNotFoundResult(
        resolvedElementQuery: ResolvedElementQuery)
        -> InteractionResult
    {
        let applicationState = applicationProvider.application.state
        let applicationStateNotice: String = applicationState == .runningForeground
            ? ""
            : ", на это могло повлиять то, что приложение не запущено, либо закрешилось (state = \(applicationState))"
        
        return failureResult(
            resolvedElementQuery: resolvedElementQuery,
            interactionSpecificFailure: nil,
            message: "элемент не найден в иерархии\(applicationStateNotice)"
        )
    }
    
    func elementIsNotUniqueResult(
        resolvedElementQuery: ResolvedElementQuery)
        -> InteractionResult
    {
        return failureResult(
            resolvedElementQuery: resolvedElementQuery,
            interactionSpecificFailure: nil,
            message: "найдено несколько элементов по заданным критериям"
        )
    }
    
    func failureResult(
        resolvedElementQuery: ResolvedElementQuery?,
        interactionSpecificFailure: InteractionSpecificFailure?,
        message: String)
        -> InteractionResult
    {
        return .failure(
            InteractionFailureMaker.interactionFailure(
                applicationProvider: applicationProvider,
                message: "\(messagePrefix) (\(interactionName)) - \(message)",
                elementFindingFailure: resolvedElementQuery?.candidatesDescription(),
                currentElementSnapshots: resolvedElementQuery?.knownSnapshots,
                interactionSpecificFailure: interactionSpecificFailure
            )
        )
    }
}
