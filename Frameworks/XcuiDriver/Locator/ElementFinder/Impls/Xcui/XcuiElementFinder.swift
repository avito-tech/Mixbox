import MixboxTestsFoundation
import MixboxUiTestsFoundation
import XCTest
import MixboxArtifacts
import MixboxReporting

public final class XcuiElementFinder: ElementFinder {
    private let stepLogger: StepLogger
    private let snapshotCaches: SnapshotCaches
    private let rootElement: XCUIElement
    // See ChangingHierarchyTests if you want to know why it is needed.
    private let rootElementCachesDroppingFunction: () -> ()
    
    public init(
        stepLogger: StepLogger,
        snapshotCaches: SnapshotCaches,
        rootElement: XCUIElement,
        rootElementCachesDroppingFunction: @escaping () -> ())
    {
        self.stepLogger = stepLogger
        self.snapshotCaches = snapshotCaches
        self.rootElement = rootElement
        self.rootElementCachesDroppingFunction = rootElementCachesDroppingFunction
    }
    
    public convenience init(
        stepLogger: StepLogger,
        snapshotCaches: SnapshotCaches,
        rootElementGetterThatDropsCaches: @escaping () -> (XCUIElement))
    {
        self.init(
            stepLogger: stepLogger,
            snapshotCaches: snapshotCaches,
            rootElement: rootElementGetterThatDropsCaches(),
            rootElementCachesDroppingFunction: { _ = rootElementGetterThatDropsCaches() }
        )
    }
    
    public func query(
        elementMatcher: ElementMatcher,
        waitForExistence: Bool)
        -> ElementQuery
    {
        let elementQueryResolvingState = ElementQueryResolvingState()
        
        rootElementCachesDroppingFunction()
        let xcuiElementQuery = rootElement.descendants(matching: .any).matching(
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
