import MixboxUiTestsFoundation
import MixboxIpc
import XCTest
import MixboxFoundation
import CocoaImageHashing
import TestsIpc

// TODO: Rename
// TODO: Add real world example tests of the screen reference matching
class ScreenshotTests: TestCase {
    private var screen: MainAppScreen<ScreenshotTestsViewPageObject> {
        return pageObjects.screenshotTestsView
    }
    
    func testExpectedColoredBoxesMatchActualColoredBoxes() {
        
        // Kludge! TODO: Enable this test
        let notIos11 = UIDevice.current.mb_iosVersion.majorVersion < 11
        let isRunningUsingEmcee = ProcessInfo.processInfo.environment["MIXBOX_CI_USES_FBXCTEST"] == "true"
        if notIos11 && isRunningUsingEmcee {
            return
        }
        // End of kludge
        
        openScreen(screen.xcui)
        
        screen.xcui.view(index: 0).assertIsDisplayed()
        
        for index in 0..<ScreenshotTestsConstants.viewsCount {
            let imageOrNil = UIImage.image(
                color: ScreenshotTestsConstants.color(index: index),
                size: ScreenshotTestsConstants.viewSize(index: index)
            )
            guard let image = imageOrNil else {
                XCTFail("Failed to create image")
                return
            }
            
            screen.forEveryKindOfHierarchy { screen in
                screen.view(index: index).withoutTimeout.assertMatchesReference(image: image)
            }
        }
    }
}
