import XCTest
import MixboxUiTestsFoundation

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
            "сфокусироваться на элементе и вставить текст 'Text' в 'input non-existing-element' с помощью физической клавиатуры" неуспешно, так как: "сфокусироваться на элементе "input non-existing-element"" неуспешно, так как: "тапнуть по "input non-existing-element"" неуспешно, так как: элемент не найден в иерархии
            """
        
        // Fails properly
        assert(logsAndFailures: logsAndFailures) { logsAndFailures in
            logsAndFailures.failures.map { $0.description } == [expectedFailure]
        }
        
        // Logs properly
        assert(logsAndFailures: logsAndFailures) { logsAndFailures in
            logsAndFailures.logs.contains { log in
                log.title == "сфокусироваться на элементе и вставить текст 'Text' в 'input non-existing-element' с помощью физической клавиатуры"
                    && log.wasSuccessful == false
                    && log.steps.contains { log in
                        log.title == "сфокусироваться на элементе \"input non-existing-element\""
                            && log.wasSuccessful == false
                            && log.steps.contains { log in
                                log.title == "тапнуть по \"input non-existing-element\""
                                    && log.wasSuccessful == false
                                    && log.steps.contains { log in
                                        log.title == "Поиск элемента" && log.wasSuccessful == false
                                    }
                            }
                    }
            }
        }
    }
}
