import MixboxFoundation
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import XCTest

final class XcuiElementQuery: ElementQuery {
    private let xcuiElementQuery: XCUIElementQuery
    private let elementQueryResolvingState: ElementQueryResolvingState
    private let stepLogger: StepLogger
    private let applicationScreenshotTaker: ApplicationScreenshotTaker
    private let applicationProvider: ApplicationProvider
    private let dateProvider: DateProvider
    private let elementFunctionDeclarationLocation: FunctionDeclarationLocation
    
    init(
        xcuiElementQuery: XCUIElementQuery,
        elementQueryResolvingState: ElementQueryResolvingState,
        stepLogger: StepLogger,
        applicationScreenshotTaker: ApplicationScreenshotTaker,
        applicationProvider: ApplicationProvider,
        dateProvider: DateProvider,
        elementFunctionDeclarationLocation: FunctionDeclarationLocation)
    {
        self.xcuiElementQuery = xcuiElementQuery
        self.elementQueryResolvingState = elementQueryResolvingState
        self.stepLogger = stepLogger
        self.applicationScreenshotTaker = applicationScreenshotTaker
        self.applicationProvider = applicationProvider
        self.dateProvider = dateProvider
        self.elementFunctionDeclarationLocation = elementFunctionDeclarationLocation
    }
    
    func resolveElement(interactionMode: InteractionMode) -> ResolvedElementQuery {
        switch interactionMode {
        case .useUniqueElement:
            return resolveElement { query in query.element }
        case .useElementAtIndexInHierarchy(let index):
            return resolveElement { query in query.element(boundBy: index) }
        }
    }
    
    // TODO: fix linter
    // swiftlint:disable:next function_body_length
    private func resolveElement(_ closure: (XCUIElementQuery) -> (XCUIElement)) -> ResolvedElementQuery {
        let stepLogBefore = StepLogBefore(
            date: dateProvider.currentDate(),
            title: "Searching for element"
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
            if let elementMatchingResultsDescription = resolvedElementQuery.elementMatchingResultsDescription() {
                attachments.append(
                    Attachment(
                        name: "Element matching results",
                        content: .text(elementMatchingResultsDescription.description)
                    )
                )
                attachments.append(
                    Attachment(
                        name: "File and line where locator is declared",
                        content: .text(
                            """
                            \(elementFunctionDeclarationLocation.fileLine.file):\(elementFunctionDeclarationLocation.fileLine.line):
                            \(elementFunctionDeclarationLocation.function)
                            """
                        )
                    )
                )
                attachments.append(
                    Attachment(
                        name: "Element hierarchy",
                        content: .text(
                            applicationProvider.application.debugDescription
                        )
                    )
                )
                if let screenshot = try? applicationScreenshotTaker.takeApplicationScreenshot() {
                    attachments.append(
                        Attachment(
                            name: "Screenshot",
                            content: .screenshot(screenshot)
                        )
                    )
                }
                attachments.append(
                    contentsOf: elementMatchingResultsDescription.attachments
                )
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
