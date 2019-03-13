import MixboxUiTestsFoundation
import MixboxIpc
import XCTest
import MixboxFoundation
import CocoaImageHashing

// TODO: Add real world example tests of the screen reference matching
class ScreenshotTests: TestCase {
    func testExpectedColoredBoxesMatchActualColoredBoxes() {
        
        // Kludge! TODO: Enable this test
        let notIos11 = UIDevice.current.mb_iosVersion.majorVersion < 11
        let isRunningUsingEmcee = ProcessInfo.processInfo.environment["MIXBOX_CI_USES_FBXCTEST"] == "true"
        if notIos11 && isRunningUsingEmcee {
            return
        }
        // End of kludge
        
        openScreen(name: "ScreenshotTestsView")
        
        pageObjects.screen.view(index: 0).assert.isDisplayed()
        
        for index in 0..<ScreenshotTestsConstants.viewsCount {
            let imageOrNil = UIImage.image(
                color: ScreenshotTestsConstants.color(index: index),
                size: ScreenshotTestsConstants.viewSize(index: index)
            )
            guard let image = imageOrNil else {
                XCTFail("Can not create image")
                return
            }
            pageObjects.screenXcui.view(index: index).withoutTimeout.assert.matchesReference(image: image)
            pageObjects.screen.view(index: index).withoutTimeout.assert.matchesReference(image: image)
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
        pageObjects.screen.catView.assert.matchesReference(image: downsampledCat)
    }
    
    private func assertCatWithTextDoesntMatchCatWithoutText() {
        let catWithText = UIImage(named: "imagehash_cat_lots_of_text", in: Bundle(for: TestCase.self), compatibleWith: nil)!
        pageObjects.screen.catView.assert.matches {
            !$0.matchesReference(image: catWithText, comparator: DHashSnapshotsComparator())
        }
    }
    
    private func assertCatDoesntMatchDog() {
        let dog = UIImage(named: "imagehash_cat_not_cat", in: Bundle(for: TestCase.self), compatibleWith: nil)!
        pageObjects.screen.catView.assert.matches {
            !$0.matchesReference(image: dog, comparator: DHashSnapshotsComparator())
        }
    }
}

private final class Screen: BasePageObjectWithDefaultInitializer {
    func view(index: Int) -> ViewElement {
        let id = ScreenshotTestsConstants.viewId(index: index)
        return element(id) { element in element.id == id }
    }
    
    var catView: ImageElement {
        return element("catView") { element in
            element.id == "catView"
        }
    }
}

private extension PageObjects {
    var screen: Screen {
        return pageObject()
    }
    var screenXcui: Screen {
        return apps.mainXcui.pageObject()
    }
}
