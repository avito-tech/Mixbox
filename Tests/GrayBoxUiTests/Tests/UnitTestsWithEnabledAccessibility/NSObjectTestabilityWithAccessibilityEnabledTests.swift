import XCTest
@testable import MixboxTestability
@testable import MixboxInAppServices
import MixboxIpcCommon

final class NSObjectTestabilityWithAccessibilityEnabledTests: TestCase {
    // NOTE: Accessibility is explicitly enabled in Gray Box Tests (see `AccessibilityOnSimulatorInitializer`).
    // The selector `accessibilityPlaceholderValue` is available.
    func test_mb_testability_accessibilityPlaceholderValue() {
        XCTAssertEqual(
            (NSObject() as TestabilityElement).mb_testability_accessibilityPlaceholderValue(),
            nil
        )
    }
}
