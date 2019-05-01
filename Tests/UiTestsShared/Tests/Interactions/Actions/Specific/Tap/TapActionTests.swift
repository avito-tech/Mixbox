import MixboxUiTestsFoundation
import XCTest

// TODO: Check tapping on overlapping views:
//
//   +-----------------------------------+
//   |a                                  |
//   |              +-----+              |
//   |              |b    |              |
//   |              |     |              |
//   |              +-----+              |
//   |                                   |
//   +-----------------------------------+
//
// Steps to reproduce: a.tap()
// Expected result: `a` tapped
// Actual result: `b` tapped
//
// It is possible to detect visible area of `a`, or that center of `a` is not visible.
//
final class TapActionTests: BaseActionTestCase {
    func test_action_canBeRunSubsequentlyWithSameResult() {
        checkActionCanBeRunSubsequentlyWithSameResult(
            actionSpecification: actionSpecification,
            resetViewsForCurrentActionSpecification: true
        )
    }
    
    func test_action_waitsElementToAppear() {
        checkActionWaitsElementToAppear(
            actionSpecification: actionSpecification
        )
    }
    
    func test_action_waitsUntilElementIsNotDuplicated() {
        checkActionWaitsUntilElementIsNotDuplicated(
            actionSpecification: actionSpecification
        )
    }
    
    private var actionSpecification: ActionSpecification<ButtonElement> {
        return ActionSpecifications.tap
    }
}
