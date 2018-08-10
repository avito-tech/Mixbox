import MixboxTestsFoundation
import MixboxUiTestsFoundation
import XCTest
import MixboxArtifacts
import MixboxReporting

protocol ElementFinder {
    func query(
        elementSnapshotMatcher: ElementSnapshotMatcher,
        waitForExistence: Bool)
        -> ElementQuery
}

final class ElementFinderImpl: ElementFinder {
    private let stepLogger: StepLogger
    
    init(stepLogger: StepLogger) {
        self.stepLogger = stepLogger
    }
    
    func query(
        elementSnapshotMatcher: ElementSnapshotMatcher,
        waitForExistence: Bool)
        -> ElementQuery
    {
        let elementQueryResolvingState = ElementQueryResolvingState()
        
        let xcuiElementQuery = XCUIApplication().descendants(matching: .any).matching(
            NSPredicate(
                block: { snapshot, _ -> Bool in
                    if let snapshot = snapshot as? XCElementSnapshot {
                        let elementSnapshot = ElementSnapshotImpl(snapshot)
                        let matchingResult = elementSnapshotMatcher.matches(snapshot: elementSnapshot)
                        
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
        
        return ElementQueryImpl(
            xcuiElementQuery: xcuiElementQuery,
            elementQueryResolvingState: elementQueryResolvingState,
            waitForExistence: waitForExistence,
            stepLogger: stepLogger
        )
    }
}
