import MixboxTestsFoundation
import MixboxUiTestsFoundation
import XCTest
import MixboxArtifacts
import MixboxReporting

final class XcuiElementQuery: ElementQuery {
    private let xcuiElementQuery: XCUIElementQuery
    private let elementQueryResolvingState: ElementQueryResolvingState
    private let waitForExistence: Bool
    private let stepLogger: StepLogger
    private let screenshotTaker: ScreenshotTaker = XcuiScreenshotTaker()
    private let snapshotCaches: SnapshotCaches
    private let applicationProvider: ApplicationProvider
    
    init(
        xcuiElementQuery: XCUIElementQuery,
        elementQueryResolvingState: ElementQueryResolvingState,
        waitForExistence: Bool,
        stepLogger: StepLogger,
        snapshotCaches: SnapshotCaches,
        applicationProvider: ApplicationProvider)
    {
        self.xcuiElementQuery = xcuiElementQuery
        self.elementQueryResolvingState = elementQueryResolvingState
        self.waitForExistence = waitForExistence
        self.stepLogger = stepLogger
        self.snapshotCaches = snapshotCaches
        self.applicationProvider = applicationProvider
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
        let stepLogBefore = StepLogBefore.other("Поиск элемента")
        
        let resolvedElementQuery = stepLogger.logStep(stepLogBefore: stepLogBefore) {
            () -> StepLoggerWrappedResult<ResolvedElementQuery>
            in
            
            let element = closure(xcuiElementQuery)
            
            elementQueryResolvingState.start()
            let elementExists = snapshotCaches.descendantsFromRoot.use { element.exists }
            elementQueryResolvingState.stop()
            
            let resolvedElementQuery = ResolvedElementQuery(
                elementQueryResolvingState: elementQueryResolvingState
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
                        content: .text(
                            snapshotCaches.descendantsFromRoot.use {
                                applicationProvider.application.debugDescription
                            }
                        )
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
