import MixboxUiTestsFoundation
import MixboxTestsFoundation

final class AssertIsNotDisplayedInteractionTests: BaseChecksTestCase {
    func test___assertIsNotDisplayed___passes_immediately___if_ui_appears_immediately_0() {
        check___assert_passes_immediately___if_ui_appears_immediately(passingAssertSpecification0)
    }
    
    func test___assertIsNotDisplayed___passes_immediately___if_ui_appears_immediately_1() {
        check___assert_passes_immediately___if_ui_appears_immediately(passingAssertSpecification1)
    }
    
    func test___assertIsNotDisplayed___fails_immediately___if_ui_doesnt_appear_immediately() {
        checkAssert(
            passes: false,
            immediately: true,
            uiLoadingActions: sequenceOfActionsWhenUiDisappears(),
            assertSpec: notImmediatelyPassingAssertSpecification
        )
    }
    
    func test___assertIsNotDisplayed___passes_not_immediately___if_ui_doesnt_appear_immediately() {
        checkAssert(
            passes: true,
            immediately: false,
            uiLoadingActions: sequenceOfActionsWhenUiDisappears(),
            assertSpec: notImmediatelyPassingAssertSpecification
        )
    }
    
    // TODO: Make optimized check for isNotDisplayed.
    //
    // Example:
    //
    // // this check always waits until timeout to ensure that element will not appear
    // elementOnView.assertIsNotDisplayedAndWillNotBeDisplayed() // <- currently implemented by assertIsNotDisplayed()
    //
    // let waitedForUi = view.waitUntilDisplayed()
    // // this check returns immediately if element is not displayed, no need to ensure that ui is loaded,
    // // because we already waited
    // elementOnView.assertIsNotDisplayed(waitedForUi: waitedForUi)
    //
    // `waitedForUi` argument guarantees that `assertIsNotDisplayed` will be executed after `waitUntilDisplayed`
    //
    func test___assertIsNotDisplayed___waits_for_element_and_fails_if_it_appears_after_some_delay() {
        checkAssert(
            passes: false,
            immediately: false,
            uiLoadingActions: sequenceOfActionsWhenUiAppears(),
            assertSpec: notImmediatelyPassingAssertSpecification
        )
    }
    
    private var passingAssertSpecification0: AssertSpecification<LabelElement> {
        return AssertSpecification(
            element: { screen in screen.isNotDisplayed0 },
            assert: { $0.assertIsNotDisplayed() }
        )
    }
    
    private var passingAssertSpecification1: AssertSpecification<LabelElement> {
        return AssertSpecification(
            element: { screen in screen.isNotDisplayed1 },
            assert: { $0.assertIsNotDisplayed() }
        )
    }
    
    private var notImmediatelyPassingAssertSpecification: AssertSpecification<LabelElement> {
        return AssertSpecification(
            element: { screen in screen.isDisplayed0 },
            assert: { $0.assertIsNotDisplayed() }
        )
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test___assertIsNotDisplayed___fails_properly_if_element_is_displayed() {
        reloadViewAndWaitUntilItIsLoaded()
        
        let logsAndFailures = recordLogsAndFailures {
            screen.isDisplayed0.withoutTimeout.assertIsNotDisplayed()
        }
        
        let failureMessage = """
            ""isDisplayed0" не является видимым" неуспешно, так как: является видимым
            """
        
        assert(logsAndFailures: logsAndFailures) { logsAndFailures in
            logsAndFailures.logs.contains { log in
                let hasSearchLogs = log.steps.contains { log in
                    hasDefaultSearchLogs(
                        log: log,
                        failureMessage: failureMessage,
                        // search isn't failed, because element was found. screenshot hash is generated only for fails
                        withScreenshotHashAttachment: false
                    )
                }
                
                let hasErrorMessageAttachment = log.attachmentsAfter.contains { attachment in
                    attachment.name == "Сообщение об ошибке"
                        && attachment.content == AttachmentContent.text(failureMessage)
                }
                
                return hasSearchLogs && hasErrorMessageAttachment
            }
        }
        
        // Fails properly
        assert(logsAndFailures: logsAndFailures) { logsAndFailures in
            logsAndFailures.failures.map { $0.description } == [failureMessage]
        }
    }
}
