import MixboxUiTestsFoundation

final class InteractionFailureResultFactoryImpl: InteractionFailureResultFactory {
    private let applicationProvider: ApplicationProvider
    private let messagePrefix: String
    private let interactionResultMaker: InteractionResultMaker
    
    init(
        applicationProvider: ApplicationProvider,
        messagePrefix: String,
        interactionResultMaker: InteractionResultMaker)
    {
        self.applicationProvider = applicationProvider
        self.messagePrefix = messagePrefix
        self.interactionResultMaker = interactionResultMaker
    }
    
    func elementIsHiddenResult()
        -> InteractionResult
    {
        return failureResult(
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
            message: "элемент не полностью видим"
                + " (видимая площадь: \(percentageOfVisibleArea),"
                + " ожидалось: \(minimalPercentageOfVisibleArea))"
                + (suffix ?? "")
        )
    }
    
    func elementIsNotFoundResult()
        -> InteractionResult
    {
        let applicationState = applicationProvider.application.state
        let applicationStateNotice: String = applicationState == .runningForeground
            ? ""
            : ", на это могло повлиять то, что приложение не запущено, либо закрешилось (state = \(applicationState))"
        
        return failureResult(
            message: "элемент не найден в иерархии\(applicationStateNotice)"
        )
    }
    
    func elementIsNotUniqueResult()
        -> InteractionResult
    {
        return failureResult(
            message: "найдено несколько элементов по заданным критериям"
        )
    }
    
    func failureResult(
        interactionFailure: InteractionFailure)
        -> InteractionResult
    {
        return interactionResultMaker.decorateFailure(interactionFailure: interactionFailure)
    }
}
