import XCTest
import MixboxTestability
import UIKit

final class UIViewTestabilityWithAccessibilityEnabledTests: TestCase {
    // NOTE: Accessibility is explicitly enabled in Gray Box Tests (see `AccessibilityOnSimulatorInitializer`).
    // The selector `accessibilityPlaceholderValue` is available.
    // This test duplicates test with same name from `UIViewTestabilityWithAccessibilityDisabledTests`,
    // but with different expected result. It should be maintained as a duplicate.
    func test_mb_testability_accessibilityPlaceholderValue() {
        let view = UITextField()

        // The default value equals to "" if placeholder is not set.
        XCTAssertEqual(
            (view as TestabilityElement).mb_testability_accessibilityPlaceholderValue(),
            ""
        )
        
        // This is how UIKit works:
        XCTAssertEqual(
            view.accessibilityPlaceholderValue() as? String,
            ""
        )
        
        view.placeholder = "text_field_placeholder"
        view.text = "text_field_text"
        
        XCTAssertEqual(
            (view as TestabilityElement).mb_testability_accessibilityPlaceholderValue(),
            "text_field_placeholder"
        )
    }
}
