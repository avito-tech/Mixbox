import MixboxUiTestsFoundation

final class AssertIsNotDisplayedInteractionTests: BaseChecksTestCase {
    func test_assert_passes_immediately_ifUiAppearsImmediately_0() {
        checkAssert_passes_immediately_ifUiAppearsImmediately(passingAssertSpecification0)
    }
    
    func test_assert_passes_immediately_ifUiAppearsImmediately_1() {
        checkAssert_passes_immediately_ifUiAppearsImmediately(passingAssertSpecification1)
    }
    
    func test_assert_fails_immediately_ifUiDoesntAppearImmediately() {
        checkAssert(
            passes: false,
            immediately: true,
            uiLoadingActions: sequenceOfActionsWhenUiDisappears(),
            assertSpec: notImmediatelyPassingAssertSpecification
        )
    }
    
    func test_assert_passes_notImmediately_ifUiDoesntAppearImmediately() {
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
    func test_assertIsNotDisplayed_waitsForElement_andFailsIfItAppearsAfterSomeDelay() {
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
    func test_assert_failsProperlyIfElementIsDisplayed() {
        reloadViewAndWaitUntilItIsLoaded()
        
        let logsAndFailures = recordLogsAndFailures {
            screen.isDisplayed0.withoutTimeout.assertIsNotDisplayed()
        }
        
        let failureMessage = """
            ""isDisplayed0" не является видимым" неуспешно, так как: является видимым
            """
        
        assert(logsAndFailures: logsAndFailures) { logsAndFailures in
            logsAndFailures.logs.contains { log in
                log.steps.contains { log in
                    hasDefaultSearchLogs(
                        log: log,
                        failureMessage: failureMessage,
                        // search isn't failed, because element was found. screenshot hash is generated only for fails
                        withScreenshotHashArtifact: false
                    )
                }
            }
        }
        
        // Fails properly
        assert(logsAndFailures: logsAndFailures) { logsAndFailures in
            logsAndFailures.failures.map { $0.description } == [failureMessage]
        }
    }
}
