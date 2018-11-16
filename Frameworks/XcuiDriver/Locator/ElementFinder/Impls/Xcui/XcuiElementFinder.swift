import MixboxTestsFoundation
import MixboxUiTestsFoundation
import XCTest
import MixboxArtifacts
import MixboxReporting

public final class XcuiElementFinder: ElementFinder {
    private let stepLogger: StepLogger
    private let snapshotCaches: SnapshotCaches
    // See ChangingHierarchyTests if you want to know why it is needed.
    private let rootElementGetterThatDropsCaches: () -> (XCUIElement)
    
    public init(
        stepLogger: StepLogger,
        snapshotCaches: SnapshotCaches,
        rootElementGetterThatDropsCaches: @escaping () -> (XCUIElement))
    {
        self.stepLogger = stepLogger
        self.snapshotCaches = snapshotCaches
        self.rootElementGetterThatDropsCaches = rootElementGetterThatDropsCaches
    }
    
    public func query(
        elementMatcher: ElementMatcher,
        waitForExistence: Bool)
        -> ElementQuery
    {
        let elementQueryResolvingState = ElementQueryResolvingState()
        
        let xcuiElementQuery = rootElementGetterThatDropsCaches().descendants(matching: .any).matching(
            NSPredicate(
                block: { snapshot, _ -> Bool in
                    if let snapshot = snapshot as? XCElementSnapshot {
                        let elementSnapshot = XcuiElementSnapshot(snapshot)
                        let matchingResult = elementMatcher.matches(value: elementSnapshot)
                        
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
            waitForExistence: waitForExistence,
            stepLogger: stepLogger,
            snapshotCaches: snapshotCaches
        )
    }
}
