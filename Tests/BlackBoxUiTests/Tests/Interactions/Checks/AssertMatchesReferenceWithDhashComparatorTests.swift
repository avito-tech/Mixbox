import MixboxUiTestsFoundation

// TODO: Rename
final class AssertMatchesReferenceWithDhashComparatorTests: TestCase {
    // TODO: Test with exact hash distances for `matchesReference` check
    func testCatImageMatching() {
        openScreen(pageObjects.screen)
        assertEqualImagesWithDifferentResolutionsMatch()
        assertCatWithTextDoesntMatchCatWithoutText()
        assertCatDoesntMatchDog()
    }
    
    private func assertEqualImagesWithDifferentResolutionsMatch() {
        let downsampledCat = UIImage(named: "imagehash_cat_size", in: Bundle(for: TestCase.self), compatibleWith: nil)!
        pageObjects.screen.catView.assertMatchesReference(image: downsampledCat)
    }
    
    private func assertCatWithTextDoesntMatchCatWithoutText() {
        let catWithText = UIImage(named: "imagehash_cat_lots_of_text", in: Bundle(for: TestCase.self), compatibleWith: nil)!
        pageObjects.screen.catView.assertMatches {
            !$0.matchesReference(image: catWithText, comparator: DHashSnapshotsComparator())
        }
    }
    
    private func assertCatDoesntMatchDog() {
        let dog = UIImage(named: "imagehash_cat_not_cat", in: Bundle(for: TestCase.self), compatibleWith: nil)!
        pageObjects.screen.catView.assertMatches {
            !$0.matchesReference(image: dog, comparator: DHashSnapshotsComparator())
        }
    }
}

private final class Screen: BasePageObjectWithDefaultInitializer, OpenableScreen {
    let viewName = "ScreenshotDHashLabelsTestsView"
    
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
}
