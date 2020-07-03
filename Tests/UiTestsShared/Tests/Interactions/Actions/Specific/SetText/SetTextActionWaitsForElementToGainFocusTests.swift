import MixboxUiTestsFoundation
import XCTest

final class SetTextActionWaitsForElementToGainFocusTests: TestCase {
    override func precondition() {
        super.precondition()
        
        open(screen: pageObjects.setTextActionWaitsForElementToGainFocusTestsView)
            .waitUntilViewIsLoaded()
    }
    
    override var reuseState: Bool {
        return false
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
        // NOTE: It was 15 before I rewrote visibility check to Swift!
        let minimumExpectedOverheadOfSetTextCommand: TimeInterval = 25
        
        // Timeout should be much greater than
        // `becomeFirstResponderDelay`
        // + `minimumExpectedOverheadOfSetTextCommand`
        // + default timeout
        // At a time setting and checking text was taking 6 seconds on a new macbook pro.
        // This is not a perfomance test, so we allow low performance in this test.
        let setTextTimeout: TimeInterval = becomeFirstResponderDelay + minimumExpectedOverheadOfSetTextCommand + 60
        
        screen.controlWithNestedTextView.withTimeout(setTextTimeout).setText(text)
        screen.textView.assertHasText(text)
        
        let stop = Date()
        let actualInterval = stop.timeIntervalSince(start)
        let minimumDelay = becomeFirstResponderDelay
        let maximumDelay = becomeFirstResponderDelay + minimumExpectedOverheadOfSetTextCommand
        XCTAssert(
            actualInterval >= minimumDelay,
            "Interaction took less time (\(actualInterval)) than expected (\(minimumDelay)). Does delay work as expected?"
        )
        XCTAssert(
            actualInterval <= maximumDelay,
            "Interaction took more time (\(actualInterval)) than expected (\(maximumDelay)). Does waiting work properly correctly?"
        )
    }
}
