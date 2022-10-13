import MixboxFoundation
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import XCTest

public final class XcuiElementFinder: ElementFinder {
    // See ChangingHierarchyTests if you want to know why dropping cache is needed.
    private let applicationProviderThatDropsCaches: ApplicationProvider
    private let resolvedElementQueryLogger: ResolvedElementQueryLogger
    private let assertionFailureRecorder: AssertionFailureRecorder
    
    public init(
        applicationProviderThatDropsCaches: ApplicationProvider,
        resolvedElementQueryLogger: ResolvedElementQueryLogger,
        assertionFailureRecorder: AssertionFailureRecorder
    ) {
        self.applicationProviderThatDropsCaches = applicationProviderThatDropsCaches
        self.resolvedElementQueryLogger = resolvedElementQueryLogger
        self.assertionFailureRecorder = assertionFailureRecorder
    }
    
    public func query(
        elementMatcher: ElementMatcher,
        elementFunctionDeclarationLocation: FunctionDeclarationLocation)
        -> ElementQuery
    {
        let elementQueryResolvingState = ElementQueryResolvingState()
        
        let xcuiElementQuery = applicationProviderThatDropsCaches.application.descendants(matching: .any).matching(
            NSPredicate(
                block: { snapshot, _ -> Bool in
                    if let snapshot = snapshot as? XCElementSnapshot {
                        let elementSnapshot = XcuiElementSnapshot(snapshot)
                        let matchingResult = elementMatcher.match(value: elementSnapshot)
                        
                        elementQueryResolvingState.append(
                            matchingResult: matchingResult,
                            elementSnapshot: elementSnapshot
                        )
                        
                        return matchingResult.matched
                    } else {
                        return false
                    }
                }
            )
        )
        
        return XcuiElementQuery(
            xcuiElementQuery: xcuiElementQuery,
            elementQueryResolvingState: elementQueryResolvingState,
            applicationProvider: applicationProviderThatDropsCaches,
            elementFunctionDeclarationLocation: elementFunctionDeclarationLocation,
            resolvedElementQueryLogger: resolvedElementQueryLogger,
            assertionFailureRecorder: assertionFailureRecorder
        )
    }
}
