import MixboxFoundation
import MixboxTestsFoundation
import MixboxIpc
import MixboxIpcCommon

final class IpcUiKitHierarchyElementQuery: ElementQuery {
    private let ipcClient: SynchronousIpcClient
    private let elementMatcher: ElementMatcher
    private let performanceLogger: PerformanceLogger
    private let elementFunctionDeclarationLocation: FunctionDeclarationLocation
    private let resolvedElementQueryLogger: ResolvedElementQueryLogger
    
    init(
        ipcClient: SynchronousIpcClient,
        elementMatcher: ElementMatcher,
        performanceLogger: PerformanceLogger,
        elementFunctionDeclarationLocation: FunctionDeclarationLocation,
        resolvedElementQueryLogger: ResolvedElementQueryLogger)
    {
        self.ipcClient = ipcClient
        self.elementMatcher = elementMatcher
        self.performanceLogger = performanceLogger
        self.elementFunctionDeclarationLocation = elementFunctionDeclarationLocation
        self.resolvedElementQueryLogger = resolvedElementQueryLogger
    }
    
    func resolveElement(interactionMode: InteractionMode) -> ResolvedElementQuery {
        resolvedElementQueryLogger.logResolvingElement(
            resolveElement: {
                resolveElementWhileBeingLogged(
                    interactionMode: interactionMode
                )
            },
            elementFunctionDeclarationLocation: elementFunctionDeclarationLocation
        )
    }
    
    // TODO: interactionMode is unused. This will produce bugs. See XcuiElementQuery for reference.
    // TODO: Write test. There is no test for that. E.g.: trying to get element #2 from matching element should
    //       produce proper failure if there is only 1 matching element. Maybe there should be also some other logic.
    private func resolveElementWhileBeingLogged(
        interactionMode: InteractionMode)
        -> ResolvedElementQueryLoggerResolvingInfo
    {
        switch viewHierarchy() {
        case .data(let viewHierarchy):
            return getResolvedElementQueryWhileBeingLogged(
                viewHierarchy: viewHierarchy
            )
        case .error(let error):
            return ResolvedElementQueryLoggerResolvingInfo(
                status: .failedToQueryElements(
                    error: "Не удалось получить иерархию вьюх из приложения: \(error)"
                ),
                elementFunctionDeclarationLocation: elementFunctionDeclarationLocation
            )
        }
    }
    
    private func viewHierarchy() -> DataResult<ViewHierarchy, Error> {
        return performanceLogger.logSignpost(staticName: "RVHEQ viewHierarchy") {
            ipcClient.call(
                method: ViewHierarchyIpcMethod()
            )
        }
    }
    
    private func getResolvedElementQueryWhileBeingLogged(viewHierarchy: ViewHierarchy)
        -> ResolvedElementQueryLoggerResolvingInfo
    {
        let resolvedElementQuery = resolveElementQuery(viewHierarchy: viewHierarchy)
        
        return ResolvedElementQueryLoggerResolvingInfo(
            status: .queryWasPerformed(
                resolvedElementQuery: resolvedElementQuery,
                provideViewHierarcyDescription:  {
                    viewHierarchy.debugDescription
                }
            ),
            elementFunctionDeclarationLocation: elementFunctionDeclarationLocation
        )
    }
    
    private func resolveElementQuery(viewHierarchy: ViewHierarchy) -> ResolvedElementQuery {
        let elementQueryResolvingState = ElementQueryResolvingState()
        
        // We don't actually need start/stop. It is a kludge for XCUI. TODO: Get rid of it.
        elementQueryResolvingState.start()
        
        performanceLogger.logSignpost(staticName: "RVHEQ all matching") {
            for element in viewHierarchy.rootElements {
                matchRecursively(element: element, state: elementQueryResolvingState)
            }
        }
        
        elementQueryResolvingState.stop()
        
        return ResolvedElementQuery(elementQueryResolvingState: elementQueryResolvingState)
    }
    
    private func matchRecursively(
        element: ViewHierarchyElement,
        parent: ElementSnapshot? = nil,
        state: ElementQueryResolvingState)
    {
        let snapshot = IpcUiKitHierarchyElementSnaphot(element: element, parent: parent)
        let matchingResult = performanceLogger.logSignpost(staticName: "RVHEQ elementMatcher.matches") {
            elementMatcher.match(value: snapshot)
        }
        state.append(matchingResult: matchingResult, elementSnapshot: snapshot)
        
        for child in element.children {
            matchRecursively(element: child, parent: snapshot, state: state)
        }
    }
}
