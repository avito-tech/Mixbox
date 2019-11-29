import TestsIpc
import XCTest
import MixboxUiTestsFoundation

final class WaitingForQuiescenceTests: TestCase {
    override func precondition() {
        super.precondition()
        
        openScreen(pageObjects.waitingForQuiescenceTestsView)
            .waitUntilViewIsLoaded()
    }
    
    private var button: ButtonElement {
        return pageObjects.waitingForQuiescenceTestsView.default.button
    }
    
    // This test isn't enough, because automatic scroll injects extra touches that cancel scroll view inertia.
    func test___action___is_performed_after_scroll_view_deceleration_ends___when_using_gentle_scroll() {
        check___action___is_performed_after_scroll_view_deceleration_ends {
            button.tap()
        }
    }
    
    // This test reproduce the bug that tests were not waiting UI to be still
    // (before waiting for quiescence was implemented for Gray box tests)
    func test___action___is_performed_after_scroll_view_deceleration_ends___when_using_swipe() {
        check___action___is_performed_after_scroll_view_deceleration_ends {
            // Swipe doesn't (and shouldn't) inject extra touches to cancel scroll view inertia.
            pageObjects.waitingForQuiescenceTestsView.default.view.swipeUp()
            button.tap()
        }
    }
    
    private func check___action___is_performed_after_scroll_view_deceleration_ends(tapAction: () -> ()) {
        // Sometimes scroll deceleration can end just right when element appears on screen.
        // But the test should check that action waits until deceleration ends, to avoid
        // any coincidences we try different offsets for view.
        for iteration in 0..<5 {
            resetUi(buttonOffset: CGFloat(iteration) * 50)
            
            tapAction()
            
            button.assertMatches {
                $0.customValues["tapped"] == true
            }
        }
    }
    
    private func resetUi(buttonOffset: CGFloat) {
        do {
            try ipcClient.callOrFail(method: ResetUiIpcMethod<CGFloat>(), arguments: buttonOffset).getVoidReturnValue()
        } catch {
            XCTFail("Error calling ResetUiIpcMethod: \(error)")
        }
    }
}
