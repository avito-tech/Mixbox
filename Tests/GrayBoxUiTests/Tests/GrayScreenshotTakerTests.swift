import MixboxUiTestsFoundation
import MixboxGray
import MixboxUiKit
import XCTest

final class GrayScreenshotTakerTests: TestCase {
    private let screenshotTaker = GrayScreenshotTaker(
        windowsProvider: WindowsProviderImpl(
            application: UIApplication.shared,
            iosVersionProvider: UiDeviceIosVersionProvider(uiDevice: UIDevice.current)
        ),
        screen: UIScreen.main
    )
    
    func test() {
        // TODO: Make specific view for this test. Reusing view with potentially
        // dynamic subviews for other kind of tests is not a good solution.
        let screen = pageObjects.screenshotTestsView.real
        
        openScreen(screen)
        
        guard let screenshot = screenshotTaker.takeScreenshot() else {
            XCTFail("takeScreenshot() should not be nil")
            return
        }
        
        // Note: tested only on iPhone 7 iOS 11.3. TODO: test on every device.
        let comparator = ImageHashCalculatorSnapshotsComparator(
            imageHashCalculator: DHashV0ImageHashCalculator(),
            hashDistanceTolerance: 7
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
