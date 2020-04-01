import TestsIpc
import XCTest
import MixboxUiTestsFoundation

final class WaitingForQuiescenceTests: TestCase {
    // Count should be > 1 to increase probability of reproducing bugs.
    private let countOfChecksForEachTest = 5
    
    override func precondition() {
        super.precondition()
        
        open(screen: pageObjects.waitingForQuiescenceTestsView)
            .waitUntilViewIsLoaded()
    }

    // This test isn't enough, because automatic scroll injects extra touches that cancel scroll view inertia.
    func test___action___is_performed_after_scroll_view_deceleration_ends___when_using_gentle_scroll() {
        check___action___is_performed_after_scroll_view_deceleration_ends {
            screen.tapIndicatorButton.tap()
        }
    }

    // This test reproduce the bug that tests were not waiting UI to be still
    // (before waiting for quiescence was implemented for Gray box tests)
    func test___action___is_performed_after_scroll_view_deceleration_ends___when_using_swipe() {
        check___action___is_performed_after_scroll_view_deceleration_ends {
            // Swipe doesn't (and shouldn't) inject extra touches to cancel scroll view inertia.
            screen.view.swipeUp()
            screen.tapIndicatorButton.tap()
        }
    }
    
    func test___action___is_performed_after_view_controller_is_pushed___animated() {
        check___action_is_performed_after_navigation_transition_ends(
            navigationPerformingButton: screen.pushButton_animated
        )
    }
    
    func test___action___is_performed_after_view_controller_is_pushed___not_animated() {
        check___action_is_performed_after_navigation_transition_ends(
            navigationPerformingButton: screen.pushButton_notAnimated
        )
    }
    
    func test___action___is_performed_after_view_controller_is_presented___animated() {
        check___action_is_performed_after_navigation_transition_ends(
            navigationPerformingButton: screen.presentButton_animated
        )
    }
    
    func test___action___is_performed_after_view_controller_is_presented___not_animated() {
        check___action_is_performed_after_navigation_transition_ends(
            navigationPerformingButton: screen.presentButton_notAnimated
        )
    }
    
    func check___action_is_performed_after_navigation_transition_ends(
        navigationPerformingButton: ButtonElement)
    {
        for _ in 0..<countOfChecksForEachTest {
            resetUi()
            
            navigationPerformingButton.tap()
            screen.centeredLineViewControllerButton.tap()
            screen.centeredLineViewControllerButton.assertMatches {
                $0.customValues["tapped"] == true
            }
        }
    }
    
    private func check___action___is_performed_after_scroll_view_deceleration_ends(tapAction: () -> ()) {
        // Sometimes scroll deceleration can end just right when element appears on screen.
        // But the test should check that action waits until deceleration ends, to avoid
        // any coincidences we try different offsets for view.
        for iteration in 0..<countOfChecksForEachTest {
            resetUi(additionalOffset: CGFloat(iteration) * 50)
            
            tapAction()
            
            screen.tapIndicatorButton.assertMatches {
                $0.customValues["tapped"] == true
            }
        }
    }
    
    private var screen: WaitingForQuiescenceTestsViewPageObject {
        return pageObjects.waitingForQuiescenceTestsView.default
    }
    
    override func resetUi() {
        resetUi(additionalOffset: 0)
    }
    
    private func resetUi(additionalOffset: CGFloat) {
        resetUi(argument: additionalOffset + UIScreen.main.bounds.height)
    }
}
