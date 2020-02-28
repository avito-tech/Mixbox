import MixboxUiTestsFoundation
import XCTest

final class SetTextActionWaitsForElementToGainFocusTests: TestCase {
    override func precondition() {
        super.precondition()
        
        openScreen(pageObjects.setTextActionWaitsForElementToGainFocusTestsView)
            .waitUntilViewIsLoaded()
    }
    
    func test___setText___waits_for_element_to_gain_focus___without_delay() {
        paramentrizedTest___setText___waits_for_element_to_gain_focus(becomeFirstResponderDelay: 0)
    }
    
    func test___setText___waits_for_element_to_gain_focus___with_delay() {
        paramentrizedTest___setText___waits_for_element_to_gain_focus(becomeFirstResponderDelay: 10)
    }
    
    func paramentrizedTest___setText___waits_for_element_to_gain_focus(becomeFirstResponderDelay: TimeInterval) {
        let text = "Text"
        let screen = pageObjects.setTextActionWaitsForElementToGainFocusTestsView.default
        
        resetUi(argument: becomeFirstResponderDelay)
        
        let start = Date()
        
        // setText might take some time even without delay
        // Values should be high enough to work reliably on CI even with high load.
        let minimumExpectedOverheadOfSetTextCommand: TimeInterval = 5
        
        // Timeout should be much greater than `becomeFirstResponderDelay` + `minimumExpectedOverheadOfSetTextCommand`
        let setTextTimeout: TimeInterval = becomeFirstResponderDelay + minimumExpectedOverheadOfSetTextCommand + 15
        
        screen.controlWithNestedTextView.withTimeout(setTextTimeout).setText(text)
        
        let stop = Date()
        
        XCTAssert(
            stop.timeIntervalSince(start) >= becomeFirstResponderDelay,
            "Interaction took less time than expected. Does delay work as expected?"
        )
        XCTAssert(
            stop.timeIntervalSince(start) <= becomeFirstResponderDelay + minimumExpectedOverheadOfSetTextCommand,
            "Interaction took less time than expected. Does waiting work properly correctly?"
        )
        
        screen.textView.assertHasText(text)
    }
}
