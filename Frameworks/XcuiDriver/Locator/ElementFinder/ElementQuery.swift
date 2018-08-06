import MixboxTestsFoundation
import MixboxUiTestsFoundation
import XCTest
import MixboxArtifacts
import MixboxReporting

protocol ElementQuery {
    func resolveElement(_ closure: (XCUIElementQuery) -> (XCUIElement)) -> ResolvedElementQuery
}

extension ElementQuery {
    func resolveElement(interactionMode: InteractionMode) -> ResolvedElementQuery {
        switch interactionMode {
        case .useUniqueElement:
            return resolveElement { query in query.element }
        case .useElementAtIndexInHierarchy(let index):
            return resolveElement { query in query.element(boundBy: index) }
        }
    }
}

final class ElementQueryImpl: ElementQuery {
    private let xcuiElementQuery: XCUIElementQuery
    private let elementQueryResolvingState: ElementQueryResolvingState
    private let waitForExistence: Bool
    private let stepLogger: StepLogger
    private let screenshotTaker: ScreenshotTaker = XcuiScreenshotTaker()
    
    init(
        xcuiElementQuery: XCUIElementQuery,
        elementQueryResolvingState: ElementQueryResolvingState,
        waitForExistence: Bool,
        stepLogger: StepLogger)
    {
        self.xcuiElementQuery = xcuiElementQuery
        self.elementQueryResolvingState = elementQueryResolvingState
        self.waitForExistence = waitForExistence
        self.stepLogger = stepLogger
    }
    
    func resolveElement(_ closure: (XCUIElementQuery) -> (XCUIElement)) -> ResolvedElementQuery {
        let stepLogBefore = StepLogBefore.other("Поиск элемента")
        
        let resolvedElementQuery = stepLogger.logStep(stepLogBefore: stepLogBefore) {
            () -> StepLoggerWrappedResult<ResolvedElementQuery>
            in
            
            let element = closure(xcuiElementQuery)
            
            elementQueryResolvingState.start()
            let elementExists = element.exists
            elementQueryResolvingState.stop()
            
            let resolvedElementQuery = ResolvedElementQuery(
                elementQueryResolvingState: elementQueryResolvingState,
                xcuiElement: element
            )
            
            var artifacts = [Artifact]()
            if !elementExists, let failureDescription = resolvedElementQuery.candidatesDescription() {
                artifacts.append(
                    Artifact(
                        name: "Кандидаты",
                        content: .text(failureDescription)
                    )
                )
                artifacts.append(
                    Artifact(
                        name: "Иерархия вьюх",
                        content: .text(XCUIApplication().debugDescription)
                    )
                )
                if let screenshot = screenshotTaker.takeScreenshot() {
                    artifacts.append(
                        Artifact(
                            name: "Скриншот",
                            content: .screenshot(screenshot)
                        )
                    )
                }
            }
            
            return StepLoggerWrappedResult(
                stepLogAfter: StepLogAfter(
                    wasSuccessful: true,
                    artifacts: artifacts
                ),
                wrappedResult: resolvedElementQuery
            )
        }
        
        return resolvedElementQuery
    }
}
