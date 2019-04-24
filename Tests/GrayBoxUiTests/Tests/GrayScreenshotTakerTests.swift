import MixboxUiTestsFoundation
import MixboxGray
import XCTest

final class GrayScreenshotTakerTests: TestCase {
    private let screenshotTaker = GrayScreenshotTaker(
        windowsProvider: WindowsProviderImpl(
            application: UIApplication.shared,
            shouldIncludeStatusBarWindow: true
        ),
        screen: UIScreen.main
    )
    
    func test() {
        let screen = pageObjects.screenshotTestsView.real
        
        openScreen(screen)
        
        guard let screenshot = screenshotTaker.takeScreenshot() else {
            XCTFail("takeScreenshot() should not be nil")
            return
        }
        
        
        let comparator = DHashSnapshotsComparator(tolerance: 20)
        
        let equals = comparator.equals(
            actual: screenshot,
            reference: image(name: "screenshotTestsView_screenshot.png")
        )
        
        XCTAssert(equals, "Screenshot doesn't match reference")
    }
}
