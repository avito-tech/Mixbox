import XCTest
import MixboxUiTestsFoundation
import MixboxTestsFoundation

// TODO: Test that logs contain all error messages:
//       Example:
//       Inside application some toast appears (e.g.: error message) for few seconds.
//       Test checks its text and it mismatches. Because of timeout it checks for tens of seconds.
//       Toast disappears.
//       Test fails because it can not find toast. But the main reason test fails is because text mismatches.
//       There is an issue now - there is no such message in logs (about text mismatches).
final class SetTextActionFailuresTests: BaseActionTestCase {
    func disabled_test_setText_withPasteInputMethod_failsProperlyIfPopupMenusDontHaveOptionsToPasteText() {
        // TODO: Implement view with custom popups.
        // Check failures
    }
    
    func test_setText_failsFast_withoutTimeout() {
        let start = Date()
        _ = gatherFailures {
            screen.input("non-existing-element").withoutTimeout.setText("Text")
        }
        let stop = Date()
        
        // If test fails before this timeout it is okay:
        let expectedTimeoutIfCodeDoesntWorkProperly: TimeInterval = 15
        
        let okTimeout = expectedTimeoutIfCodeDoesntWorkProperly - 1
        
        XCTAssertLessThan(
            stop.timeIntervalSince1970 - start.timeIntervalSince1970,
            okTimeout,
            "It seems that `withoutTimeout` doesn't work"
        )
    }
    
    func test_setText_failsProperly_forNonExistingElement() {
        let logsAndFailures = recordLogsAndFailures {
            screen.input("non-existing-element").withoutTimeout.setText("Text")
        }
        
        let expectedFailure = """
            "focus on element and paste text 'Text' into 'input non-existing-element' using physical keyboard" failed, because: "focus on element "input non-existing-element"" failed, because: "tap "input non-existing-element"" failed, because: element was not found in hierarchy
            """
        
        // Fails properly
        assert(logsAndFailures: logsAndFailures) { logsAndFailures in
            logsAndFailures.failures.map { $0.description } == [expectedFailure]
        }
        
        // Logs properly
        assert(logsAndFailures: logsAndFailures) { logsAndFailures in
            logsAndFailures.logs.contains { log in
                log.title == "focus on element and paste text 'Text' into 'input non-existing-element' using physical keyboard"
                    && log.wasSuccessful == false
                    && log.steps.contains { log in
                        log.title == "focus on element \"input non-existing-element\""
                            && log.wasSuccessful == false
                            && log.steps.contains { log in
                                log.title == "tap \"input non-existing-element\""
                                    && log.wasSuccessful == false
                                    && log.steps.contains { log in
                                        log.title == "Searching for element" && log.wasSuccessful == false
                                    }
                            }
                    }
            }
        }
    }
}
