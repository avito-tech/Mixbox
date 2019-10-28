import MixboxUiTestsFoundation
import MixboxIpc
import XCTest
import MixboxFoundation
import CocoaImageHashing
import TestsIpc

class AssertMatchesReferenceWithPerPixelComparatorTests: TestCase {
    private var screen: MainAppScreen<ScreenshotTestsViewPageObject> {
        return pageObjects.screenshotTestsView
    }
    
    func testExpectedColoredBoxesMatchActualColoredBoxes() {
        openScreen(screen.xcui)
        
        screen.xcui.view(index: 0).assertIsDisplayed()
        
        for index in 0..<ScreenshotTestsConstants.viewsCount {
            assertDoesntThrow {
                let image = try UIImage.image(
                    color: ScreenshotTestsConstants.color(index: index),
                    size: ScreenshotTestsConstants.viewSize(index: index).mb_floor()
                )
                
                screen.forEveryKindOfHierarchy { screen in
                    screen.view(index: index).withoutTimeout.assertMatchesReference(
                        image: image,
                        comparatorType: .perPixel
                    )
                }
            }
        }
    }
}
