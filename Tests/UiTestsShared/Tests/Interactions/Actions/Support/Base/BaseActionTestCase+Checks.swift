import XCTest
import MixboxUiTestsFoundation
import TestsIpc

extension BaseActionTestCase {
    func checkActionCausesExpectedResultIfIsPerformedOnce(
        actionSpecification: AnyActionSpecification,
        resetViewsForCurrentActionSpecification: Bool,
        errorMessageSuffix: () -> String = { "" })
    {
        checkActionCanBeRunSubsequentlyWithSameResult(
            actionSpecification: actionSpecification,
            numberOfSubsequentActions: 1,
            resetViewsForCurrentActionSpecification: resetViewsForCurrentActionSpecification,
            errorMessageSuffix: errorMessageSuffix
        )
    }
    
    func checkActionCanBeRunSubsequentlyWithSameResult(
        actionSpecification: AnyActionSpecification,
        numberOfSubsequentActions: Int = 5,
        resetViewsForCurrentActionSpecification: Bool,
        errorMessageSuffix: () -> String = { "" })
    {
        if resetViewsForCurrentActionSpecification {
            setViews(
                ui: ui(repeating: actionSpecification, count: 1)
            )
        }
        
        for iteration in 0..<numberOfSubsequentActions {
            actionSpecification.performAction(screen: screen)
            assertAndResetResult(equals: actionSpecification.expectedResult) { expectedResult, actualResult in
                let iterationInfo = numberOfSubsequentActions > 1 ? " at iteration \(iteration)" : ""
                
                return """
                Result of action is unexpected: expected \(expectedResult), \
                got \(actualResult)\(iterationInfo)\(errorMessageSuffix())
                """
            }
        }
    }
    
    func checkActionWaitsElementToAppear<T: Element>(
        actionSpecification: ActionSpecification<T>)
    {
        let specForUi = actionSpecification
        
        checkActionWaits(
            actionSpecification: actionSpecification,
            uiBeforeDelay: ui(repeating: specForUi, count: 0),
            uiAfterDelay: ui(repeating: specForUi, count: 1)
        )
        
        checkActionWaits(
            actionSpecification: actionSpecification,
            uiBeforeDelay: ui(repeating: specForUi, count: 1, alpha: 0),
            uiAfterDelay: ui(repeating: specForUi, count: 1)
        )
        
        checkActionWaits(
            actionSpecification: actionSpecification,
            uiBeforeDelay: ui(repeating: specForUi, count: 1, isHidden: true),
            uiAfterDelay: ui(repeating: specForUi, count: 1)
        )
        
        checkActionWaits(
            actionSpecification: actionSpecification,
            uiBeforeDelay: ui(repeating: specForUi, count: 1, overlapping: 0.7),
            uiAfterDelay: ui(repeating: specForUi, count: 1)
        )
    }
    
    func checkActionWaitsUntilElementIsNotDuplicated<T: Element>(
        actionSpecification: ActionSpecification<T>)
    {
        let specForUi = actionSpecification
        
        checkActionWaits(
            actionSpecification: actionSpecification,
            uiBeforeDelay: ui(repeating: specForUi, count: 2),
            uiAfterDelay: ui(repeating: specForUi, count: 1)
        )
    }
    
    private func ui(
        repeating: AnyActionSpecification,
        count: Int,
        alpha: CGFloat = 1,
        isHidden: Bool = false,
        overlapping: CGFloat = 0)
        -> ActionsTestsViewModel
    {
        return ActionsTestsViewModel(
            showInfo: true,
            viewNames: Array(repeating: repeating, count: count).map { $0.elementId },
            alpha: alpha,
            isHidden: isHidden,
            overlapping: overlapping,
            touchesAreBlocked: false
        )
    }
    
    private func checkActionWaits<T: Element>(
        actionSpecification: ActionSpecification<T>,
        uiBeforeDelay: ActionsTestsViewModel,
        uiAfterDelay: ActionsTestsViewModel)
    {
        let delay: TimeInterval = 5
        let timeout: TimeInterval = 30
        let dispatchQueue = DispatchQueue(label: String(#function))
        
        // Prepare UI for failing
        dispatchQueue.sync { [weak self] in
            self?.setViews(ui: uiBeforeDelay)
        }
        
        // Set up UI so action will stop failing after delay
        dispatchQueue.async { [weak self, waiter] in
            waiter.wait(timeout: delay)
            self?.setViews(ui: uiAfterDelay)
        }
        
        // Should fail and retry
        let element = actionSpecification.element(screen).withTimeout(timeout)
        actionSpecification.action(element)
    }
}
