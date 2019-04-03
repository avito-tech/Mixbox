import MixboxUiTestsFoundation
import MixboxReporting
import MixboxArtifacts

// TODO: Test `assertMatchesReference`. Test that it generates image attachments.
// TODO: Test isDisplayed (without `assert`).
// TODO: Test `matches`.
// TODO: Test `value`.
// TODO: Test `text`.
// TODO: Test `accessibilityLabel`.
// TODO: Test `assertMatches`.
class BaseChecksTestCase: TestCase {
    override var reuseState: Bool {
        return false
    }
    
    override func precondition() {
        openScreen(name: "ChecksTestsView")
        screen.waitUntilUiIsLoaded()
    }
    
    var screen: ChecksTestsScreen {
        return pageObjects.checksTestsScreen
    }
    
    // MARK: - Common checks
    
    func checkAssert_passes_immediately_ifUiAppearsImmediately<T: Element>(_ assertSpec: AssertSpecification<T>) {
        checkAssert(
            passes: true,
            immediately: true,
            uiAppearsImmediately: true,
            assertSpec: assertSpec
        )
    }
    
    func checkAssert_fails_immediately_ifUiDoesntAppearImmediately<T: Element>(_ assertSpec: AssertSpecification<T>) {
        checkAssert(
            passes: false,
            immediately: true,
            uiAppearsImmediately: false,
            assertSpec: assertSpec
        )
    }
    
    func checkAssert_passes_notImmediately_ifUiDoesntAppearImmediately<T: Element>(_ assertSpec: AssertSpecification<T>) {
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
        let logsAndFailures = recordLogsAndFailures {
            body()
        }
        
        assert(logsAndFailures: logsAndFailures) { logsAndFailures in
            logsAndFailures.logs.contains { log in
                let defaultMatcher = hasDefaultSearchLogs(
                    log: log,
                    failureMessage: failureMessage,
                    withScreenshotHashArtifact: true
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
    
    func hasDefaultSearchLogs(
        log: StepLogMatcherBuilder,
        failureMessage: String,
        withScreenshotHashArtifact: Bool)
        -> Matcher<StepLog>
    {
        let hasSearchStep = log.steps.contains { log in
            let isSearchStep = log.detailedDescription == "Поиск элемента"
            
            let hasCandidatesAttachment = log.artifactsAfter.contains { artifact in
                artifact.name == "Кандидаты"
            }
            
            let hasScreenshotAttachment = log.artifactsAfter.contains { artifact in
                artifact.name == "Скриншот"
            }
            
            let hasHierarchyAttachment = log.artifactsAfter.contains { artifact in
                artifact.name == "Иерархия вьюх"
            }
            
            let hasAllRequiredAttachments = hasCandidatesAttachment
                && hasScreenshotAttachment
                && hasHierarchyAttachment
            
            return isSearchStep && hasAllRequiredAttachments
        }
        
        let hasScreenshotBeforeAttachment = log.artifactsBefore.contains { artifact in
            artifact.name == "Скриншот до"
        }
        
        let hasScreenshotAfterAttachment = log.artifactsAfter.contains { artifact in
            artifact.name == "Скриншот после"
        }
        
        let hasFileLineAttachment = log.artifactsAfter.contains { artifact in
            artifact.name == "File and line"
        }
        
        let hasErrorAttachment = log.artifactsAfter.contains { artifact in
            artifact.name == "Сообщение об ошибке"
                && artifact.content == ArtifactContent.text(failureMessage)
        }
        
        var hasAllRequiredAttachments: Matcher<StepLog> = hasScreenshotBeforeAttachment
            && hasScreenshotAfterAttachment
            && hasFileLineAttachment
        
        if withScreenshotHashArtifact {
            let hasScreenshotHashAttachment = log.artifactsAfter.contains { artifact in
                artifact.name == "hash скриншота DHashV0ImageHashCalculator после"
            }
            hasAllRequiredAttachments = hasAllRequiredAttachments && hasScreenshotHashAttachment
        }
        
        return hasSearchStep && hasAllRequiredAttachments
    }
    
    // MARK: - Sequence of actions
    
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
    
    // MARK: - Private
    
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
            reloadViewWithDelays(uiLoadingActions: uiLoadingActions)
        } else {
            reloadViewWithoutDelays()
        }
        
        Thread.sleep(forTimeInterval: 1)
        
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
    
    private func reloadViewWithDelays(uiLoadingActions: [ChecksTestsViewConfiguration.Action]) {
        _ = ipcClient.call(
            method: ConfigureChecksTestsViewIpcMethod(),
            arguments: ChecksTestsViewConfiguration(
                actions: uiLoadingActions
            )
        )
    }
    
    private func reloadViewWithoutDelays() {
        _ = ipcClient.call(
            method: ConfigureChecksTestsViewIpcMethod(),
            arguments: ChecksTestsViewConfiguration.default
        )
    }
}

private extension PageObjects {
    var checksTestsScreen: ChecksTestsScreen {
        return pageObject()
    }
}
