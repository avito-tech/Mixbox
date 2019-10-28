import MixboxTestsFoundation
import MixboxUiTestsFoundation
import XCTest

final class XcuiElementQuery: ElementQuery {
    private let xcuiElementQuery: XCUIElementQuery
    private let elementQueryResolvingState: ElementQueryResolvingState
    private let stepLogger: StepLogger
    private let screenshotTaker: ScreenshotTaker
    private let applicationProvider: ApplicationProvider
    private let dateProvider: DateProvider
    
    init(
        xcuiElementQuery: XCUIElementQuery,
        elementQueryResolvingState: ElementQueryResolvingState,
        stepLogger: StepLogger,
        screenshotTaker: ScreenshotTaker,
        applicationProvider: ApplicationProvider,
        dateProvider: DateProvider)
    {
        self.xcuiElementQuery = xcuiElementQuery
        self.elementQueryResolvingState = elementQueryResolvingState
        self.stepLogger = stepLogger
        self.screenshotTaker = screenshotTaker
        self.applicationProvider = applicationProvider
        self.dateProvider = dateProvider
    }
    
    func resolveElement(interactionMode: InteractionMode) -> ResolvedElementQuery {
        switch interactionMode {
        case .useUniqueElement:
            return resolveElement { query in query.element }
        case .useElementAtIndexInHierarchy(let index):
            return resolveElement { query in query.element(boundBy: index) }
        }
    }
    
    private func resolveElement(_ closure: (XCUIElementQuery) -> (XCUIElement)) -> ResolvedElementQuery {
        let stepLogBefore = StepLogBefore(
            date: dateProvider.currentDate(),
            title: "Поиск элемента"
        )
        
        let wrapper = stepLogger.logStep(stepLogBefore: stepLogBefore) {
            () -> StepLoggerResultWrapper<ResolvedElementQuery>
            in
            
            let element = closure(xcuiElementQuery)
            
            elementQueryResolvingState.start()
            // TODO?: Optimize logging. Do not log if element is found.
            let elementExists = element.exists
            elementQueryResolvingState.stop()
            
            let resolvedElementQuery = ResolvedElementQuery(
                elementQueryResolvingState: elementQueryResolvingState
            )
            
            var attachments = [Attachment]()
            if let failureDescription = resolvedElementQuery.candidatesDescription() {
                attachments.append(
                    Attachment(
                        name: "Кандидаты",
                        content: .text(failureDescription)
                    )
                )
                attachments.append(
                    Attachment(
                        name: "Иерархия вьюх",
                        content: .text(
                            applicationProvider.application.debugDescription
                        )
                    )
                )
                if let screenshot = screenshotTaker.takeScreenshot() {
                    attachments.append(
                        Attachment(
                            name: "Скриншот",
                            content: .screenshot(screenshot)
                        )
                    )
                }
            }
            
            return StepLoggerResultWrapper(
                stepLogAfter: StepLogAfter(
                    date: dateProvider.currentDate(),
                    wasSuccessful: elementExists,
                    attachments: attachments
                ),
                wrappedResult: resolvedElementQuery
            )
        }
        
        return wrapper.wrappedResult
    }
}
