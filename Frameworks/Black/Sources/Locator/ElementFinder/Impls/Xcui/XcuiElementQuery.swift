import MixboxFoundation
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import XCTest

final class XcuiElementQuery: ElementQuery {
    private let xcuiElementQuery: XCUIElementQuery
    private let elementQueryResolvingState: ElementQueryResolvingState
    private let applicationProvider: ApplicationProvider
    private let elementFunctionDeclarationLocation: FunctionDeclarationLocation
    private let resolvedElementQueryLogger: ResolvedElementQueryLogger
    private let assertionFailureRecorder: AssertionFailureRecorder
    
    init(
        xcuiElementQuery: XCUIElementQuery,
        elementQueryResolvingState: ElementQueryResolvingState,
        applicationProvider: ApplicationProvider,
        elementFunctionDeclarationLocation: FunctionDeclarationLocation,
        resolvedElementQueryLogger: ResolvedElementQueryLogger,
        assertionFailureRecorder: AssertionFailureRecorder
    ) {
        self.xcuiElementQuery = xcuiElementQuery
        self.elementQueryResolvingState = elementQueryResolvingState
        self.applicationProvider = applicationProvider
        self.elementFunctionDeclarationLocation = elementFunctionDeclarationLocation
        self.resolvedElementQueryLogger = resolvedElementQueryLogger
        self.assertionFailureRecorder = assertionFailureRecorder
    }
    
    func resolveElement(interactionMode: InteractionMode) -> ResolvedElementQuery {
        switch interactionMode {
        case .useUniqueElement:
            return resolveElement { query in query.element }
        case .useElementAtIndexInHierarchy(let index):
            return resolveElement { query in query.element(boundBy: index) }
        }
    }
    
    private func resolveElement(
        _ closure: (XCUIElementQuery) -> (XCUIElement)
    ) -> ResolvedElementQuery {
        return resolvedElementQueryLogger.logResolvingElement(
            resolveElement: {
                resolveElementWithoutLogging(
                    closure: closure
                )
            },
            elementFunctionDeclarationLocation: elementFunctionDeclarationLocation
        )
    }
    
    private func resolveElementWithoutLogging(
        closure: (XCUIElementQuery) -> (XCUIElement)
    ) -> ResolvedElementQueryLoggerResolvingInfo {
        let element = closure(xcuiElementQuery)
        
        elementQueryResolvingState.start()
        // TODO?: Optimize logging. Do not log if element is found.
        let elementExists = element.exists
        elementQueryResolvingState.stop()
        
        let resolvedElementQuery = ResolvedElementQuery(
            elementQueryResolvingState: elementQueryResolvingState
        )
        
        let elementWasFound = resolvedElementQuery.elementWasFound
        
        if elementExists != elementWasFound {
            assertionFailureRecorder.recordAssertionFailure(
                message:
                """
                Value of \(XCUIElement.self)'s property `exists` (\(elementExists)) \
                is not equal to value of \(ResolvedElementQuery.self)'s property `elementWasFound` (\(elementWasFound)).
                """
            )
        }
        
        return ResolvedElementQueryLoggerResolvingInfo(
            status: .queryWasPerformed(
                resolvedElementQuery: resolvedElementQuery,
                provideViewHierarcyDescription: { [applicationProvider] in
                    applicationProvider.application.debugDescription
                }
            ),
            elementFunctionDeclarationLocation: elementFunctionDeclarationLocation
        )
    }
}
