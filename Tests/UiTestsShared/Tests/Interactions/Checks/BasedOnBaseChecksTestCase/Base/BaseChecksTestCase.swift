import MixboxUiTestsFoundation
import MixboxTestsFoundation
import TestsIpc

// todos by methods:
//
// TODO: Test `assertMatchesReference`. Test that it generates image attachments.
// TODO: Test `isDisplayed` (without `assert`).
// TODO: Test `matches`.
// TODO: Test `value`.
// TODO: Test `text`.
// TODO: Test `accessibilityLabel`.
// TODO: Test `assertMatches`.
//
// todos by conditions:
//
// TODO: Test WebView
// TODO: Test different UI hierarchies.
//
class BaseChecksTestCase: TestCase {
    override var reuseState: Bool {
        return false
    }
    
    override func precondition() {
        super.precondition()
        
        openScreen(screen)
        screen.waitUntilViewIsLoaded()
    }
    
    var screen: ChecksTestsScreen {
        return pageObjects.checksTestsScreen
    }
    
    // MARK: - Common checks
    
    func check___assert_passes_immediately___if_ui_appears_immediately<T: Element>(_ assertSpec: AssertSpecification<T>) {
        checkAssert(
            passes: true,
            immediately: true,
            uiAppearsImmediately: true,
            assertSpec: assertSpec
        )
    }
    
    func check___assert_fails_immediately___if_ui_doesnt_appear_immediately<T: Element>(_ assertSpec: AssertSpecification<T>) {
        checkAssert(
            passes: false,
            immediately: true,
            uiAppearsImmediately: false,
            assertSpec: assertSpec
        )
    }
    
    func check___assert_passes_not_immediately___if_ui_doesnt_appear_immediately<T: Element>(_ assertSpec: AssertSpecification<T>) {
        checkAssert(
            passes: true,
            immediately: false,
            uiAppearsImmediately: false,
            assertSpec: assertSpec
        )
    }
    
    func checkAssertFailsWithDefaultLogs(
        failureMessage: String,
        additionalLogs: ((StepLogMatcherBuilder) -> Matcher<StepLog>)? = nil,
        body: () -> ())
    {
        reloadViewAndWaitUntilItIsLoaded()
        
        let logsAndFailures = recordLogsAndFailures {
            body()
        }
        
        assert(logsAndFailures: logsAndFailures) { logsAndFailures in
            logsAndFailures.logs.contains { log in
                let defaultMatcher = hasDefaultSearchLogs(
                    log: log,
                    failureMessage: failureMessage,
                    withScreenshotHashAttachment: true
                )
                
                if let additionalLogs = additionalLogs {
                    return defaultMatcher && additionalLogs(log)
                } else {
                    return defaultMatcher
                }
            }
        }
        
        // Fails properly
        assert(logsAndFailures: logsAndFailures) { logsAndFailures in
            logsAndFailures.failures.map { $0.description } == [failureMessage]
        }
    }
    
    func checkAssert<T: Element>(
        passes: Bool,
        immediately: Bool,
        uiAppearsImmediately: Bool,
        assertSpec: AssertSpecification<T>)
    {
        checkAssert(
            passes: passes,
            immediately: immediately,
            uiLoadingActions: uiAppearsImmediately
                ? nil
                : sequenceOfActionsWhenUiAppears(),
            assertSpec: assertSpec
        )
    }
    
    func checkAssert<T: Element>(
        passes: Bool,
        immediately: Bool,
        uiLoadingActions: [ChecksTestsViewConfiguration.Action]?,
        assertSpec: AssertSpecification<T>)
    {
        if let uiLoadingActions = uiLoadingActions {
            reloadView(uiLoadingActions: uiLoadingActions)
        } else {
            reloadViewAndWaitUntilItIsLoaded()
        }
        
        assert(passes: passes) {
            let element: T
            
            if immediately {
                element = assertSpec.element(screen).withoutTimeout
            } else {
                element = assertSpec.element(screen).withTimeout(30)
            }
            
            assertSpec.assert(element)
        }
    }
    
    // MARK: - Mathing
    
    func hasDefaultSearchLogs(
        log: StepLogMatcherBuilder,
        failureMessage: String,
        withScreenshotHashAttachment: Bool)
        -> Matcher<StepLog>
    {
        let hasSearchStep = log.steps.contains { log in
            let isSearchStep = log.title == "Поиск элемента"
            
            let hasCandidatesAttachment = log.attachmentsAfter.contains { attachment in
                attachment.name == "Кандидаты"
            }
            
            let hasScreenshotAttachment = log.attachmentsAfter.contains { attachment in
                attachment.name == "Скриншот"
            }
            
            let hasHierarchyAttachment = log.attachmentsAfter.contains { attachment in
                attachment.name == "Иерархия вьюх"
            }
            
            let hasAllRequiredAttachments = hasCandidatesAttachment
                && hasScreenshotAttachment
                && hasHierarchyAttachment
            
            return isSearchStep && hasAllRequiredAttachments
        }
        
        let hasScreenshotBeforeAttachment = log.attachmentsBefore.contains { attachment in
            attachment.name == "Скриншот до"
        }
        
        let hasScreenshotAfterAttachment = log.attachmentsAfter.contains { attachment in
            attachment.name == "Скриншот после"
        }
        
        let hasFileLineAttachment = log.attachmentsAfter.contains { attachment in
            attachment.name == "File and line"
        }
        
        var hasAllRequiredAttachments: Matcher<StepLog> = hasScreenshotBeforeAttachment
            && hasScreenshotAfterAttachment
            && hasFileLineAttachment
        
        if withScreenshotHashAttachment {
            let hasScreenshotHashAttachment = log.attachmentsAfter.contains { attachment in
                attachment.name == "hash скриншота DHashV0ImageHashCalculator после"
            }
            hasAllRequiredAttachments = hasAllRequiredAttachments && hasScreenshotHashAttachment
        }
        
        return hasSearchStep && hasAllRequiredAttachments
    }
    
    // MARK: - Sequence of actions
    
    func sequenceOfActionsWhenUiAppearsImmediately() -> [ChecksTestsViewConfiguration.Action] {
        let action = ChecksTestsViewConfiguration.Action(
            reloadSettings: ChecksTestsViewConfiguration.ReloadSettings(
                defaultConfig: true,
                setId: true,
                userConfig: true,
                addSubview: true
            ),
            delay: 0
        )
        
        return [action]
    }
    
    func sequenceOfActionsWhenUiDisappears() -> [ChecksTestsViewConfiguration.Action] {
        let delay: TimeInterval = 4
        
        func action(step: Int) -> ChecksTestsViewConfiguration.Action {
            return ChecksTestsViewConfiguration.Action(
                reloadSettings: ChecksTestsViewConfiguration.ReloadSettings(
                    defaultConfig: step < 2,
                    setId: step < 3, // this is when assertIsNotDisplayed() should pass
                    userConfig: step < 1,
                    addSubview: step < 4
                ),
                delay: step == 0
                    ? 0 // first step - show all UI instantly
                    : delay
            )
        }
        
        return (0...4).map { action(step: $0) }
    }
    
    func sequenceOfActionsWhenUiAppears() -> [ChecksTestsViewConfiguration.Action] {
        let delay: TimeInterval = 4
        
        func action(step: Int) -> ChecksTestsViewConfiguration.Action {
            return ChecksTestsViewConfiguration.Action(
                reloadSettings: ChecksTestsViewConfiguration.ReloadSettings(
                    defaultConfig: step >= 3,
                    setId: step >= 2,
                    userConfig: step >= 4,
                    addSubview: step >= 1
                ),
                delay: step == 0
                    ? 0 // first step - remove all UI instantly
                    : delay
            )
        }
        
        return (0...4).map { action(step: $0) }
    }
    
    // MARK: - Reloading view
    
    func reloadView(uiLoadingActions: [ChecksTestsViewConfiguration.Action]) {
        _ = ipcClient.call(
            method: ConfigureChecksTestsViewIpcMethod(),
            arguments: ChecksTestsViewConfiguration(
                actions: uiLoadingActions
            )
        )
    }
    
    func reloadViewAndWaitUntilItIsLoaded() {
        reloadView(uiLoadingActions: [.default])
        
        // Wait until UI is loaded:
        screen.isDisplayed0.assertIsDisplayed()
    }
}
