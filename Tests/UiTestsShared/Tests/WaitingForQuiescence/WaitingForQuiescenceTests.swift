import TestsIpc
import XCTest
import MixboxUiTestsFoundation

final class WaitingForQuiescenceTests: TestCase {
    // Count should be > 1 to increase probability of reproducing bugs.
    private let countOfChecksForEachTest = 5
    private let tapIndicatorButtonId = "tapIndicatorButton"
    
    override func precondition() {
        super.precondition()
        
        open(screen: pageObjects.waitingForQuiescenceTestsView)
            .waitUntilViewIsLoaded()
    }

    // This test isn't enough, because automatic scroll injects extra touches that cancel scroll view inertia.
    func test___action___is_performed_after_scroll_view_deceleration_ends___when_using_gentle_scroll() {
        check___action___is_performed_after_scroll_view_deceleration_ends {
            tapIndicatorButton.tap()
        }
    }

    // This test reproduce the bug that tests were not waiting UI to be still
    // (before waiting for quiescence was implemented for Gray box tests)
    func test___action___is_performed_after_scroll_view_deceleration_ends___when_using_swipe() {
        check___action___is_performed_after_scroll_view_deceleration_ends {
            // Swipe doesn't (and shouldn't) inject extra touches to cancel scroll view inertia.
            screen.view.swipeUp()
            tapIndicatorButton.tap()
        }
    }
    
    func disabled_test___action___is_performed_after_scroll_view_bouncing_ends___when_using_gentle_scroll() {
        check___action___is_performed_after_scroll_view_bouncing_ends {
            tapIndicatorButton.tap()
        }
    }
    
    func disabled_test___action___is_performed_after_scroll_view_bouncing_ends___when_using_swipe() {
        check___action___is_performed_after_scroll_view_bouncing_ends {
            screen.view.swipeUp()
            tapIndicatorButton.tap()
        }
    }
    
    func test___action___is_performed_after_view_controller_is_pushed___animated() {
        check___action_is_performed_after_navigation_transition_ends(
            navigationPerformingButton: .push(animated: true)
        )
    }
    
    func test___action___is_performed_after_view_controller_is_pushed___not_animated() {
        check___action_is_performed_after_navigation_transition_ends(
            navigationPerformingButton: .push(animated: false)
        )
    }
    
    func test___action___is_performed_after_view_controller_is_presented___animated() {
        check___action_is_performed_after_navigation_transition_ends(
            navigationPerformingButton: .present(animated: true)
        )
    }
    
    func test___action___is_performed_after_view_controller_is_presented___not_animated() {
        check___action_is_performed_after_navigation_transition_ends(
            navigationPerformingButton: .present(animated: false)
        )
    }
    
    private func check___action___is_performed_after_scroll_view_deceleration_ends(tapAction: () -> ()) {
        // Sometimes scroll deceleration can end just right when element appears on screen.
        // But the test should check that action waits until deceleration ends, to avoid
        // any coincidences we try different offsets for view.
        for iteration in 0..<countOfChecksForEachTest {
            resetUiForCheckingScrollDeceleration(
                randomizedAdditionalOffset: CGFloat(iteration) * 50
            )
            
            tapAction()
            
            tapIndicatorButton.withoutTimeout.assertMatches {
                $0.customValues["tapped"] == true
            }
        }
    }
    
    private func check___action___is_performed_after_scroll_view_bouncing_ends(tapAction: () -> ()) {
        for iteration in 0..<countOfChecksForEachTest {
            resetUiForCheckingScrollBouncing(
                randomizedAdditionalOffset: CGFloat(iteration) * 50
            )
            
            tapAction()
            
            tapIndicatorButton.withoutTimeout.assertMatches {
                $0.customValues["tapped"] == true
            }
        }
    }
    
    func check___action_is_performed_after_navigation_transition_ends(
        navigationPerformingButton: WaitingForQuiescenceTestsViewConfiguration.ActionButton)
    {
        for _ in 0..<countOfChecksForEachTest {
            resetUiForCheckingNavigation(
                navigationPerformingButton: navigationPerformingButton
            )
            
            screen.button(navigationPerformingButton.id).tap()
            
            screen.centeredLineViewControllerButton.tap()
            screen.centeredLineViewControllerButton.withoutTimeout.assertMatches {
                $0.customValues["tapped"] == true
            }
        }
    }
    
    private var screen: WaitingForQuiescenceTestsViewPageObject {
        return pageObjects.waitingForQuiescenceTestsView.default
    }
    
    private var tapIndicatorButton: ButtonElement {
        return screen.button(tapIndicatorButtonId)
    }
    
    private func resetUiForCheckingScrollDeceleration(randomizedAdditionalOffset: CGFloat) {
        // The idea is to maximize deceleration path. To do this we place button outside of initially visible area
        // and have much space in scroll view to avoid bouncing.
        resetUi(
            argument: WaitingForQuiescenceTestsViewConfiguration(
                contentSize: CGSize(width: UIScreen.main.bounds.width, height: 10000),
                tapIndicatorButtons: [
                    .init(id: tapIndicatorButtonId, offset: UIScreen.main.bounds.height + randomizedAdditionalOffset)
                ],
                actionButtons: []
            )
        )
    }
    
    private func resetUiForCheckingScrollBouncing(randomizedAdditionalOffset: CGFloat) {
        // The idea is to maximize bouncing distance. To do this we place the button just above the
        // content bounds (close to the point where bouncing can happen) and below initially visible area.
        // Ideally the path of gesture will equal bouncing distance.
        resetUi(
            argument: WaitingForQuiescenceTestsViewConfiguration(
                contentSize: CGSize(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height + 10 + randomizedAdditionalOffset),
                tapIndicatorButtons: [
                    .init(
                        id: tapIndicatorButtonId,
                        offset: UIScreen.main.bounds.height + randomizedAdditionalOffset
                    )
                ],
                actionButtons: []
            )
        )
    }
    
    private func resetUiForCheckingNavigation(navigationPerformingButton: WaitingForQuiescenceTestsViewConfiguration.ActionButton) {
        resetUi(
            argument: WaitingForQuiescenceTestsViewConfiguration(
                contentSize: UIScreen.main.bounds.size,
                tapIndicatorButtons: [],
                actionButtons: [navigationPerformingButton]
            )
        )
    }
}
