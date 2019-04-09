import XCTest
import MixboxUiTestsFoundation

// TODO: Test fails.
// TODO: Test that LoggingElementInteractionWithDependenciesPerformer reports attachments in nestedFailures in InteractionFailure.
class BaseActionTestCase: TestCase {
    
    // MARK: - Screen
    
    override func precondition() {
        openScreen(name: "ActionsTestsView")
        
        // wait
        _ = screen.screenView.isDisplayed()
    }
    
    var screen: ActionsTestsScreen {
        return pageObjects.actionsTestsScreen
    }
    
    // MARK: - ActionSpecification
    
    // Open-Closed principle is violated due to testcase, when random series of actions is tested.
    // Every new action should be tested if it affects other action.
    // TODO: How to detect if some action is not tested thoroughly?
    
    let tapActionSpecification = ActionSpecification<ButtonElement>(
        elementId: "tap",
        action: { $0.tap() },
        expectedResult: "tap"
    )
    
    let pressActionSpecification = ActionSpecification<ButtonElement>(
        elementId: "press",
        action: { $0.press(duration: 1.2) },
        expectedResult: "press"
    )
    
    func setTextActionSpecification(
        text: String,
        inputMethod: SetTextActionFactory.InputMethod? = nil)
        -> ActionSpecification<InputElement>
    {
        return ActionSpecification(
            elementId: "text",
            action: { element in
                if let inputMethod = inputMethod {
                    element.setText(text, inputMethod: inputMethod)
                } else {
                    element.setText(text)
                }
            },
            expectedResult: "text: \(text)"
        )
    }
    
    let clearTextActionSpecification = ActionSpecification<InputElement>(
        elementId: "text",
        action: { element in
            element.setText("Введенная строка")
            element.clearText()
        },
        expectedResult: "text: "
    )
    
    let swipeUpActionSpecification = ActionSpecification<LabelElement>(
        elementId: "swipeUp",
        action: { $0.swipeUp() },
        expectedResult: "swipeUp"
    )
    
    let swipeDownActionSpecification = ActionSpecification<LabelElement>(
        elementId: "swipeDown",
        action: { $0.swipeDown() },
        expectedResult: "swipeDown"
    )
    
    let swipeLeftActionSpecification = ActionSpecification<LabelElement>(
        elementId: "swipeLeft",
        action: { $0.swipeLeft() },
        expectedResult: "swipeLeft"
    )
    
    let swipeRightActionSpecification = ActionSpecification<LabelElement>(
        elementId: "swipeRight",
        action: { $0.swipeRight() },
        expectedResult: "swipeRight"
    )
    
    var allActionSpecifications: [AnyActionSpecification] {
        let text = "Text that is set"
        return [
            tapActionSpecification,
            pressActionSpecification,
            setTextActionSpecification(text: text, inputMethod: .paste),
            setTextActionSpecification(text: text, inputMethod: .pasteUsingPopupMenus),
            setTextActionSpecification(text: text, inputMethod: .type),
            swipeUpActionSpecification,
            swipeDownActionSpecification,
            swipeLeftActionSpecification,
            swipeRightActionSpecification
        ]
    }
    
    // MARK: - Checks
    
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
        let actionSpecification = actionSpecification
        
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
                    Result of action is unexpected: expected \(prettyPrintedResult(expectedResult)), \
                    got \(prettyPrintedResult(actualResult))\(iterationInfo)\(errorMessageSuffix())
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
            overlapping: overlapping
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
        dispatchQueue.async { [weak self] in
            Thread.sleep(forTimeInterval: delay)
            self?.setViews(ui: uiAfterDelay)
        }
        
        // Should fail and retry
        let element = actionSpecification.element(screen).withTimeout(timeout)
        actionSpecification.action(element)
    }
    
    // MARK: -
    
    func setViews(
        showInfo: Bool,
        actionSpecifications: [AnyActionSpecification])
    {
        setViews(
            ui: ActionsTestsViewModel(
                showInfo: showInfo,
                viewNames: actionSpecifications.map { $0.elementId },
                alpha: 1,
                isHidden: false,
                overlapping: 0
            )
        )
    }
    
    // MARK: - Private
    
    private func prettyPrintedResult(_ result: String?) -> String {
        if let result = result {
            return "\"\(result)\""
        } else {
            // TODO: Enum dedicated to a result, to replace "nil" with a meaningful case.
            return "<UI was not triggered>"
        }
    }
    
    private func assertAndResetResult(equals expectedResult: String?, describeFailure: (String?, String?) -> String) {
        let timeout: TimeInterval = 5
        let pollInterval: TimeInterval = 0.1
        let maxIterations = Int(timeout / pollInterval)
        let lastInteration = maxIterations - 1
        
        for iteration in 0..<maxIterations {
            let actualResult = ipcClient.callOrFail(
                method: GetActionResultIpcMethod()
            )
            
            if actualResult == expectedResult || iteration == lastInteration {
                // Better to reset UI before failing
                if let error = ipcClient.callOrFail(method: ResetActionResultIpcMethod()) {
                    XCTFail("Error calling ResetActionResultIpcMethod: \(error)")
                }
                
                XCTAssertEqual(expectedResult, actualResult, describeFailure(expectedResult, actualResult))
                break
            }
            
            Thread.sleep(forTimeInterval: pollInterval)
        }
    }
    
    private func setViews(
        ui: ActionsTestsViewModel)
    {
        let error = ipcClient.callOrFail(
            method: SetViewsIpcMethod(),
            arguments: ui
        )
        
        if let error = error {
            XCTFail(error.value)
        }
    }
}
