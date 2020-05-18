import TestsIpc
import XCTest
import MixboxUiTestsFoundation

final class WaitingForQuiescenceTests: TestCase {
    // Count should be > 1 to increase probability of reproducing bugs.
    private let countOfChecksForEachTest = 5
    private let tapIndicatorButtonId = "tapIndicatorButton"
    private let buttonWithCoreAnimationColorChangeId = WaitingForQuiescenceTestsViewConfiguration.ActionButton.withCoreAnimation(.colorChange).id
    private let buttonWithCoreAnimationColorMoveId = WaitingForQuiescenceTestsViewConfiguration.ActionButton.withCoreAnimation(.move).id
    
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
    
    func test___action___is_performed_after_scroll_view_bouncing_ends___when_using_gentle_scroll() {
        check___action___is_performed_after_scroll_view_bouncing_ends {
            tapIndicatorButton.tap()
        }
    }
    
    func test___action___is_performed_after_scroll_view_bouncing_ends___when_using_swipe() {
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
    
    func test___action___is_performed_after_set_content_offset_finished() {
        for _ in 0..<countOfChecksForEachTest {
            let animationButton = WaitingForQuiescenceTestsViewConfiguration.ActionButton.setContentOffsetAnimated(
                offset: UIScreen.main.bounds.height
            )
            resetForSettingContentOffset(
                animationButton: animationButton,
                height: UIScreen.main.bounds.height * 3,
                tapIndicatorOffset: UIScreen.main.bounds.height * 1.5
            )
            
            screen.button(animationButton.id).withoutTimeout.tap()
            
            tapIndicatorButton.withoutTimeout.tap()
        }
    }
    
    private var isRunningInBlackBox: Bool {
        // TODO: currently, Mixbox in black box test mode uses XCUI private APIs to _waitForQuiescence(), and does not use Mixbox' idling resource tracker.
        // XCUI apparently does not support tracking CA animations. This test will fail because of that.
        // This check should be removed when Mixbox will allow to use IPC for app quiescence tracking.
        return ProcessInfo.processInfo.processName.hasSuffix("-Runner")
    }

    // Animations in this test are very slow, so there is no need to perform check multiple times (countOfChecksForEachTest)
    func test___waits_for_core_animation_to_complete___before_querying_values() {
        if isRunningInBlackBox { return }
        
        resetUi(actionButton: .withCoreAnimation(.colorChange))
        
        buttonWithCoreAnimationColorChange.tap()
        
        buttonWithCoreAnimationColorChange.withoutTimeout.assertMatches {
            $0.customValues["core_animation_has_finished"] == true
        }
    }
    
    // Animations in this test are very slow, so there is no need to perform check multiple times (countOfChecksForEachTest)
    func test___waits_for_core_animation_to_complete___before_tapping() {
        if isRunningInBlackBox { return }
        
        resetUi(actionButton: .withCoreAnimation(.move))
        
        buttonWithCoreAnimationMove.tap()
        buttonWithCoreAnimationMove.tap()
        
        buttonWithCoreAnimationMove.withoutTimeout.assertMatches {
            $0.customValues["tap_count"] == 2
        }
    }
    
    private func check___action___is_performed_after_scroll_view_deceleration_ends(tapAction: () -> ()) {
        // Sometimes scroll deceleration can end just right when element appears on screen.
        // But the test should check that action waits until deceleration ends, to avoid
        // any coincidences we try different offsets for view.
        for iteration in 0..<countOfChecksForEachTest {
            resetUiForCheckingScrollDeceleration(
                randomizedAdditionalOffset: CGFloat(iteration) * 50
            )
            
            tapIndicatorButton.withoutTimeout.assert(isTapped: false)
            
            tapAction()
            
            tapIndicatorButton.withoutTimeout.assert(isTapped: true)
        }
    }
    
    private func check___action___is_performed_after_scroll_view_bouncing_ends(tapAction: () -> ()) {
        for iteration in 0..<countOfChecksForEachTest {
            resetUiForCheckingScrollBouncing(
                randomizedAdditionalOffset: CGFloat(iteration) * 50
            )
            
            tapIndicatorButton.withoutTimeout.assert(isTapped: false)
            
            tapAction()
            
            tapIndicatorButton.withoutTimeout.assert(isTapped: true)
        }
    }
    
    func check___action_is_performed_after_navigation_transition_ends(
        navigationPerformingButton: WaitingForQuiescenceTestsViewConfiguration.ActionButton)
    {
        for _ in 0..<countOfChecksForEachTest {
            resetUi(
                actionButton: navigationPerformingButton
            )
            
            screen.button(navigationPerformingButton.id).tap()
            
            screen.centeredLineViewControllerButton.withoutTimeout.assert(isTapped: false)
            
            screen.centeredLineViewControllerButton.tap()
            
            screen.centeredLineViewControllerButton.withoutTimeout.assert(isTapped: true)
        }
    }
    
    private var screen: WaitingForQuiescenceTestsViewPageObject {
        return pageObjects.waitingForQuiescenceTestsView.default
    }
    
    private var tapIndicatorButton: TapIndicatorButtonElement {
        return screen.tapIndicatorButton(tapIndicatorButtonId)
    }
    
    private var buttonWithCoreAnimationColorChange: ButtonElement {
        return screen.button(buttonWithCoreAnimationColorChangeId)
    }
    
    private var buttonWithCoreAnimationMove: ButtonElement {
        return screen.button(buttonWithCoreAnimationColorMoveId)
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
    
    private func resetUi(actionButton: WaitingForQuiescenceTestsViewConfiguration.ActionButton) {
        resetUi(
            argument: WaitingForQuiescenceTestsViewConfiguration(
                contentSize: UIScreen.main.bounds.size,
                tapIndicatorButtons: [],
                actionButtons: [actionButton]
            )
        )
    }
    
    private func resetForSettingContentOffset(
        animationButton: WaitingForQuiescenceTestsViewConfiguration.ActionButton,
        height: CGFloat,
        tapIndicatorOffset: CGFloat)
    {
        resetUi(
            argument: WaitingForQuiescenceTestsViewConfiguration(
                contentSize: CGSize(
                    width: UIScreen.main.bounds.width,
                    height: height
                ),
                tapIndicatorButtons: [
                    .init(
                        id: tapIndicatorButtonId,
                        offset: tapIndicatorOffset
                    )
                ],
                actionButtons: [
                    animationButton
                ]
            )
        )
    }
}
