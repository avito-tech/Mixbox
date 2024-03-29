import MixboxFoundation
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import XCTest

public final class XcuiElementFinder: ElementFinder {
    private let stepLogger: StepLogger
    // See ChangingHierarchyTests if you want to know why dropping cache is needed.
    private let applicationProviderThatDropsCaches: ApplicationProvider
    private let applicationScreenshotTaker: ApplicationScreenshotTaker
    private let dateProvider: DateProvider
    
    public init(
        stepLogger: StepLogger,
        applicationProviderThatDropsCaches: ApplicationProvider,
        applicationScreenshotTaker: ApplicationScreenshotTaker,
        dateProvider: DateProvider)
    {
        self.stepLogger = stepLogger
        self.applicationProviderThatDropsCaches = applicationProviderThatDropsCaches
        self.applicationScreenshotTaker = applicationScreenshotTaker
        self.dateProvider = dateProvider
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
            stepLogger: stepLogger,
            applicationScreenshotTaker: applicationScreenshotTaker,
            applicationProvider: applicationProviderThatDropsCaches,
            dateProvider: dateProvider,
            elementFunctionDeclarationLocation: elementFunctionDeclarationLocation
        )
    }
}
