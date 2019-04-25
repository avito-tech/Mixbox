import MixboxUiTestsFoundation
import MixboxIpc
import XCTest
import MixboxFoundation
import CocoaImageHashing

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
                XCTFail("Can not create image")
                return
            }
            
            screen.forEveryKindOfHierarchy { screen in
                screen.view(index: index).withoutTimeout.assertMatchesReference(image: image)
            }
        }
        
    }
    
    // TODO: Test with exact hash distances for `matchesReference` check
    func testCatImageMatching() {
        openScreen(name: "ScreenshotDHashLabelsTestsView")
        assertEqualImagesWithDifferentResolutionsMatch()
        assertCatWithTextDoesntMatchCatWithoutText()
        assertCatDoesntMatchDog()
    }
    
    private func assertEqualImagesWithDifferentResolutionsMatch() {
        let downsampledCat = UIImage(named: "imagehash_cat_size", in: Bundle(for: TestCase.self), compatibleWith: nil)!
        screen.xcui.catView.assertMatchesReference(image: downsampledCat)
    }
    
    private func assertCatWithTextDoesntMatchCatWithoutText() {
        let catWithText = UIImage(named: "imagehash_cat_lots_of_text", in: Bundle(for: TestCase.self), compatibleWith: nil)!
        screen.xcui.catView.assertMatches {
            !$0.matchesReference(image: catWithText, comparator: DHashSnapshotsComparator())
        }
    }
    
    private func assertCatDoesntMatchDog() {
        let dog = UIImage(named: "imagehash_cat_not_cat", in: Bundle(for: TestCase.self), compatibleWith: nil)!
        screen.xcui.catView.assertMatches {
            !$0.matchesReference(image: dog, comparator: DHashSnapshotsComparator())
        }
    }
}
