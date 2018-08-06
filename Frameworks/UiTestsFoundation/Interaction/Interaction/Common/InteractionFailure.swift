// Полное описание ошибке по взаимодействию (пример: тап, проверка на текст)
public final class InteractionFailure {
    public let message: String
    public let error: NSError?
    public let screenshotAtFailure: UIImage?
    public let applicationUiHierarchy: String?
    public let betterUiHierarchy: String?
    public let stackTrace: [String]
    public let testCaseName: String?
    public let testMethodName: String?
    
    // Содержит всю специфическую по действию информацию (в отличие от остальных полей).
    // То есть здесь конкретно что не так пошло, например, в проверке на текст
    // или в проверке на снепшоты. Опционально, так как до специфики может не дойти, например,
    // если элемент будет не найден.
    public let interactionSpecificFailure: InteractionSpecificFailure?

    public init(
        message: String,
        error: NSError?,
        screenshotAtFailure: UIImage?,
        applicationUiHierarchy: String?,
        betterUiHierarchy: String? = nil,
        stackTrace: [String],
        testCaseName: String?,
        testMethodName: String?,
        interactionSpecificFailure: InteractionSpecificFailure? = nil)
    {
        self.message = message
        self.error = error
        self.screenshotAtFailure = screenshotAtFailure
        self.applicationUiHierarchy = applicationUiHierarchy
        self.betterUiHierarchy = betterUiHierarchy
        self.stackTrace = stackTrace
        self.testCaseName = testCaseName
        self.testMethodName = testMethodName
        self.interactionSpecificFailure = interactionSpecificFailure
    }
}
