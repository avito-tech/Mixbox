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
            message: "элемент есть в иерархии, но спрятан"
        )
    }
    
    public func elementIsNotSufficientlyVisibleResult(
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
    
    public func elementIsNotFoundResult()
        -> InteractionResult
    {
        let applicationStateNotice: String
            
        do {
            let applicationState = try applicationStateProvider.applicationState()
            
            applicationStateNotice = applicationState == .runningForeground
                ? ""
                : ", на это могло повлиять то, что приложение не запущено, либо закрешилось (state = \(applicationState))"
        } catch {
            applicationStateNotice = ", при попытке получить стейт приложения, чтобы определить закрешилось приложение или нет возникла ошибка: \(error)"
        }
        
        return failureResult(
            message: "элемент не найден в иерархии\(applicationStateNotice)"
        )
    }
    
    public func elementIsNotUniqueResult()
        -> InteractionResult
    {
        return failureResult(
            message: "найдено несколько элементов по заданным критериям"
        )
    }
    
    public func failureResult(
        interactionFailure: InteractionFailure)
        -> InteractionResult
    {
        return interactionResultMaker.decorateFailure(interactionFailure: interactionFailure)
    }
}
