import MixboxFoundation
import MixboxReporting
import MixboxIpc
import MixboxIpcCommon
import MixboxArtifacts

final class RealViewHierarchyElementQuery: ElementQuery {
    private let ipcClient: IpcClient
    private let elementMatcher: ElementMatcher
    private let testFailureRecorder: TestFailureRecorder
    private let waitForExistence: Bool
    private let stepLogger: StepLogger
    private let screenshotTaker: ScreenshotTaker
    
    init(
        ipcClient: IpcClient,
        elementMatcher: ElementMatcher,
        testFailureRecorder: TestFailureRecorder,
        stepLogger: StepLogger,
        screenshotTaker: ScreenshotTaker,
        waitForExistence: Bool)
    {
        self.ipcClient = ipcClient
        self.elementMatcher = elementMatcher
        self.testFailureRecorder = testFailureRecorder
        self.waitForExistence = waitForExistence
        self.stepLogger = stepLogger
        self.screenshotTaker = screenshotTaker
    }
    
    func resolveElement(interactionMode: InteractionMode) -> ResolvedElementQuery {
        let stepLogBefore = StepLogBefore.other("Поиск элемента")
        
        // TODO: Extract code to functions
        let wrapper = stepLogger.logStep(stepLogBefore: stepLogBefore) { () -> StepLoggerResultWrapper<ResolvedElementQuery> in
            let result = ipcClient.call(
                method: ViewHierarchyIpcMethod()
            )
            
            let elementQueryResolvingState = ElementQueryResolvingState()
            
            var artifacts = [Artifact]()
            let resolvedElementQuery: ResolvedElementQuery
            
            if let viewHierarchy = result.data {
                // We don't actually need start/stop. TODO!
                elementQueryResolvingState.start()
                
                for element in viewHierarchy.rootElements {
                    matchRecursively(element: element, state: elementQueryResolvingState)
                }
                
                elementQueryResolvingState.stop()
                
                resolvedElementQuery = ResolvedElementQuery(elementQueryResolvingState: elementQueryResolvingState)
                
                if let failureDescription = resolvedElementQuery.candidatesDescription() {
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
                                viewHierarchy.debugDescription
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
            } else {
                resolvedElementQuery = ResolvedElementQuery(elementQueryResolvingState: elementQueryResolvingState)
                
                // TODO: better FileLine
                testFailureRecorder.recordFailure(
                    description: "Не удалось получить иерархию вьюх из приложения",
                    fileLine: FileLine.current(),
                    shouldContinueTest: false
                )
            }
            
            return StepLoggerResultWrapper(
                stepLogAfter: StepLogAfter(
                    wasSuccessful: true,
                    artifacts: artifacts
                ),
                wrappedResult: resolvedElementQuery
            )
        }
        
        return wrapper.wrappedResult
    }
    
    private func matchRecursively(
        element: ViewHierarchyElement,
        parent: ElementSnapshot? = nil,
        state: ElementQueryResolvingState)
    {
        let snapshot = RealViewHierarchyElementSnaphot(element: element, parent: parent)
        let matchingResult = elementMatcher.matches(value: snapshot)
        state.append(matchingResult: matchingResult, elementSnapshot: snapshot)
        
        for child in element.children {
            matchRecursively(element: child, parent: snapshot, state: state)
        }
    }
}
