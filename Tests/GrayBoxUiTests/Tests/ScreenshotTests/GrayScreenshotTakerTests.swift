import MixboxUiTestsFoundation
import MixboxGray
import MixboxUiKit
import XCTest
import MixboxInAppServices

final class GrayScreenshotTakerTests: TestCase {
    func test() {
        // TODO: Make specific view for this test. Reusing view with potentially
        // dynamic subviews for other kind of tests is not a good solution.
        let screen = pageObjects.screenshotTestsView.uikit
        
        open(screen: screen)
        
        let grayScreenshotTaker = dependencies.resolve() as ScreenshotTaker
        
        XCTAssert(grayScreenshotTaker is GrayScreenshotTaker)
        
        guard let screenshot = grayScreenshotTaker.takeScreenshot() else {
            XCTFail("takeScreenshot() should not be nil")
            return
        }
        
        let comparator = ImageHashCalculatorSnapshotsComparator(
            imageHashCalculator: DHashV0ImageHashCalculator(),
            hashDistanceTolerance: 8,
            shouldIgnoreTransparency: true
        )
        
        let result = comparator.compare(
            actualImage: screenshot,
            expectedImage: image(name: "screenshotTestsView_screenshot.png")
        )
        
        switch result {
        case .similar:
            break
        case .different(let description):
            XCTFail("Screenshot doesn't match reference: \(description.message)")
        }
    }
}
