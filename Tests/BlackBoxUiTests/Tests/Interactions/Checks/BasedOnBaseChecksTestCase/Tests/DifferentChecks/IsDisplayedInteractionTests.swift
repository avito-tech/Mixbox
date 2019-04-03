import MixboxUiTestsFoundation
import XCTest

final class IsDisplayedInteractionTests: BaseChecksTestCase {
    func test_xctassert_isDisplayed_passes_immediately_ifUiAppearsImmediately() {
        checkAssert_passes_immediately_ifUiAppearsImmediately(passingAssertSpecification())
    }
    
    func test_xctassert_isDisplayed_fails_immediately_ifUiDoesntAppearImmediately() {
        checkAssert_fails_immediately_ifUiDoesntAppearImmediately(passingAssertSpecification())
    }
    
    private func passingAssertSpecification() -> AssertSpecification<LabelElement> {
        return AssertSpecification(
            element: { screen in screen.isDisplayed0 },
            assert: { XCTAssert($0.isDisplayed()) }
        )
    }
    
    func test_isDisplayed_doesntFailTest_0() {
        assertPasses {
            _ = screen.isNotDisplayed0.isDisplayed()
        }
    }
    
    func test_isDisplayed_doesntFailTest_1() {
        assertPasses {
            _ = screen.isNotDisplayed1.isDisplayed()
        }
    }
}
