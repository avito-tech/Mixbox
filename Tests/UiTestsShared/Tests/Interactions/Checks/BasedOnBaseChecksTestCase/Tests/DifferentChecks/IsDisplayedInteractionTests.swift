import MixboxUiTestsFoundation
import XCTest

final class IsDisplayedInteractionTests: BaseChecksTestCase {
    func test___isDisplayed___returns_true_immediately___if_ui_appears_immediately() {
        check___assert_passes_immediately___if_ui_appears_immediately(passingAssertSpecification())
    }
    
    func test___isDisplayed___returns_false_immediately___if_ui_doesnt_appear_immediately() {
        check___assert_fails_immediately___if_ui_doesnt_appear_immediately(passingAssertSpecification())
    }
    
    private func passingAssertSpecification() -> AssertSpecification<LabelElement> {
        return AssertSpecification(
            element: { screen in screen.isDisplayed0 },
            assert: { XCTAssert($0.isDisplayed()) }
        )
    }
    
    func test___isDisplayed___doesnt_fail_test___0() {
        assertPasses {
            _ = screen.isNotDisplayed0.isDisplayed()
        }
    }
    
    func test___isDisplayed___doesnt_fail_test___1() {
        assertPasses {
            _ = screen.isNotDisplayed1.isDisplayed()
        }
    }
}
