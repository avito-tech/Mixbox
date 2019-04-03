import MixboxTestsFoundation
import MixboxUiTestsFoundation
import XCTest
import MixboxArtifacts
import MixboxReporting

public final class XcuiElementFinder: ElementFinder {
    private let stepLogger: StepLogger
    // See ChangingHierarchyTests if you want to know why dropping cache is needed.
    private let applicationProviderThatDropsCaches: ApplicationProvider
    private let screenshotTaker: ScreenshotTaker
    
    public init(
        stepLogger: StepLogger,
        applicationProviderThatDropsCaches: ApplicationProvider,
        screenshotTaker: ScreenshotTaker)
    {
        self.stepLogger = stepLogger
        self.applicationProviderThatDropsCaches = applicationProviderThatDropsCaches
        self.screenshotTaker = screenshotTaker
    }
    
    public func query(
        elementMatcher: ElementMatcher,
        waitForExistence: Bool)
        -> ElementQuery
    {
        let elementQueryResolvingState = ElementQueryResolvingState()
        
        let xcuiElementQuery = applicationProviderThatDropsCaches.application.descendants(matching: .any).matching(
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
            screenshotTaker: screenshotTaker,
            applicationProvider: applicationProviderThatDropsCaches
        )
    }
}
