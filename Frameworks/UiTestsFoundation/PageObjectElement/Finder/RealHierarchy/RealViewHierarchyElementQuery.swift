import MixboxFoundation
import MixboxReporting
import MixboxIpc
import MixboxIpcCommon
import MixboxArtifacts

final class RealViewHierarchyElementQuery: ElementQuery {
    private let ipcClient: IpcClient
    private let elementMatcher: ElementMatcher
    private let testFailureRecorder: TestFailureRecorder
    private let stepLogger: StepLogger
    private let screenshotTaker: ScreenshotTaker
    
    init(
        ipcClient: IpcClient,
        elementMatcher: ElementMatcher,
        testFailureRecorder: TestFailureRecorder,
        stepLogger: StepLogger,
        screenshotTaker: ScreenshotTaker)
    {
        self.ipcClient = ipcClient
        self.elementMatcher = elementMatcher
        self.testFailureRecorder = testFailureRecorder
        self.stepLogger = stepLogger
        self.screenshotTaker = screenshotTaker
    }
    
    func resolveElement(interactionMode: InteractionMode) -> ResolvedElementQuery {
        let stepLogBefore = StepLogBefore.other("Поиск элемента")
        
        let wrapper = stepLogger.logStep(stepLogBefore: stepLogBefore) {
            resolveElementWhileBeingLogged(interactionMode: interactionMode)
        }
        
        return wrapper.wrappedResult
    }
    
    // TODO: interactionMode is unused. This will produce bugs. See XcuiElementQuery for reference.
    // TODO: Write test. There is no test for that. E.g.: trying to get element #2 from matching element should
    //       produce proper failure if there is only 1 matching element. Maybe there should be also some other logic.
    private func resolveElementWhileBeingLogged(
        interactionMode: InteractionMode)
        -> StepLoggerResultWrapper<ResolvedElementQuery>
    {
        switch viewHierarchy() {
        case .data(let viewHierarchy):
            return getResolvedElementQueryWhileBeingLogged(viewHierarchy: viewHierarchy)
        case .error(let error):
            return reportIpcFailedWhileGettingHierarchy(error: error)
        }
    }
    
    private func viewHierarchy()
        -> DataResult<ViewHierarchy, IpcClientError>
    {
        return ipcClient.call(
            method: ViewHierarchyIpcMethod()
        )
    }
    
    private func reportIpcFailedWhileGettingHierarchy(
        error: IpcClientError)
        -> StepLoggerResultWrapper<ResolvedElementQuery>
    {
        // TODO: better FileLine (should point to invocation in test)
        testFailureRecorder.recordFailure(
            description: "Не удалось получить иерархию вьюх из приложения",
            fileLine: FileLine.current(),
            shouldContinueTest: false
        )
        
        // TODO: Get rid of ElementQueryResolvingState, it is only a kludge for XCUI
        let emptyState = ElementQueryResolvingState()
        emptyState.start()
        emptyState.stop()
        
        let emptyQuery = ResolvedElementQuery(
            elementQueryResolvingState: emptyState
        )
        
        return StepLoggerResultWrapper(
            stepLogAfter: StepLogAfter(
                wasSuccessful: false,
                artifacts: []
            ),
            wrappedResult: emptyQuery
        )
    }
    
    private func getResolvedElementQueryWhileBeingLogged(viewHierarchy: ViewHierarchy)
        -> StepLoggerResultWrapper<ResolvedElementQuery>
    {
        let resolvedElementQuery = resolveElementQuery(viewHierarchy: viewHierarchy)
        
        return log(resolvedElementQuery: resolvedElementQuery, viewHierarchy: viewHierarchy)
    }
    
    private func resolveElementQuery(viewHierarchy: ViewHierarchy) -> ResolvedElementQuery {
        let elementQueryResolvingState = ElementQueryResolvingState()
        
        // We don't actually need start/stop. It is a kludge for XCUI. TODO: Get rid of it.
        elementQueryResolvingState.start()
        
        for element in viewHierarchy.rootElements {
            matchRecursively(element: element, state: elementQueryResolvingState)
        }
        
        elementQueryResolvingState.stop()
        
        return ResolvedElementQuery(elementQueryResolvingState: elementQueryResolvingState)
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
    
    private func log(resolvedElementQuery: ResolvedElementQuery, viewHierarchy: ViewHierarchy)
        -> StepLoggerResultWrapper<ResolvedElementQuery>
    {
        let elementWasFound = resolvedElementQuery.matchingSnapshots.count > 0
        
        return StepLoggerResultWrapper(
            stepLogAfter: StepLogAfter(
                wasSuccessful: elementWasFound,
                artifacts: artifactsForLog(
                    resolvedElementQuery: resolvedElementQuery,
                    viewHierarchy: viewHierarchy
                )
            ),
            wrappedResult: resolvedElementQuery
        )
    }
    
    // TODO: This logic is copypasted from XcuiElementQuery. Share.
    private func artifactsForLog(resolvedElementQuery: ResolvedElementQuery, viewHierarchy: ViewHierarchy) -> [Artifact] {
        var artifacts = [Artifact]()
        
        if let candidatesDescription = resolvedElementQuery.candidatesDescription() {
            artifacts.append(
                Artifact(
                    name: "Кандидаты",
                    content: .text(candidatesDescription)
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
        
        return artifacts
    }
}
