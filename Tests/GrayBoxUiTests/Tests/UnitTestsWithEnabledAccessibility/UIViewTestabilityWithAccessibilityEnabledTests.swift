import XCTest
import MixboxTestability
import UIKit

final class UIViewTestabilityWithAccessibilityEnabledTests: TestCase {
    func test_mb_testability_accessibilityPlaceholderValue() {
        let view = UITextField()

        // The default value equals to `nil` if placeholder is not set.
        XCTAssertEqual(
            (view as TestabilityElement).mb_testability_accessibilityPlaceholderValue(),
            nil
        )
        
        // This is how UIKit works:
        XCTAssertEqual(
            view.value(forKey: "accessibilityPlaceholderValue") as? String,
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
