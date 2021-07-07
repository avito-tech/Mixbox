import MixboxUiTestsFoundation
import MixboxTestsFoundation
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
        
        let applicationScreenshotTaker = dependencies.resolve() as ApplicationScreenshotTaker
        let deviceScreenshotTaker = dependencies.resolve() as DeviceScreenshotTaker
        
        XCTAssert(applicationScreenshotTaker is GrayScreenshotTaker)
        XCTAssertIdentical(applicationScreenshotTaker, deviceScreenshotTaker)
        
        let screenshot = UnavoidableFailure.doOrFail {
            try applicationScreenshotTaker.takeApplicationScreenshot()
        }
        
        let comparator = ImageHashCalculatorSnapshotsComparator(
            imageHashCalculator: DHashImageHashCalculator(),
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
