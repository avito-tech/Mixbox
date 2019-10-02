import MixboxUiTestsFoundation
import XCTest

// TODO: Rename
final class AssertMatchesReferenceWithDhashComparatorTests: TestCase {
    override var reuseState: Bool {
        return false
    }
    
    override func precondition() {
        super.precondition()
        
        openScreen(pageObjects.screen)
        pageObjects.screen.waitUntilViewIsLoaded()
    }
    
    func test___image_with_different_resolution___match() {
        assertImageMatchesReference(
            imageName: "imagehash_cat_size",
            // TODO: Should match with 0 tolerance.
            //       There is probably a bug with layout on iPhone 7 iOS 11.3 / Xcode 10.1 / High Sierra / Emcee runner.
            //       I can't reproduce it with iPhone 7 iOS 11.3 / Xcode 10.2 / Mojave / Xcode runner.
            //       And I don't have reports on CI.
            tolerance: 11
        )
    }
    
    func test___image_overlapped_with_lots_of_text___doesnt_match() {
        assertImageDoesntMatchReference(
            imageName: "imagehash_cat_lots_of_text",
            tolerance: 10
        )
    }
    
    func test___different_image___doesnt_match() {
        assertImageDoesntMatchReference(
            imageName: "imagehash_cat_not_cat",
            tolerance: 10
        )
    }
    
    private func assertImageMatchesReference(imageName: String, tolerance: UInt8) {
        guard let referenceImage = image(named: imageName) else {
            XCTFail("Couldn't load image \(imageName)")
            return
        }
        
        pageObjects.screen.catView.withoutTimeout.assertMatchesReference(
            image: referenceImage,
            comparator: comparator(tolerance: tolerance)
        )
    }
    
    private func assertImageDoesntMatchReference(imageName: String, tolerance: UInt8) {
        let e = NSRegularExpression.escapedPattern(for:)
        let decimalHashDistance = "[0-9]{1,2}"
        let binaryHash = "[01]{64}"
        
        let errorRegex = e(
            """
            "проверить, что "catView" соответствует референсному изображению" неуспешно, так как: проверка неуспешна (Совпадает с референсным скрином): Actual hashDistance is below hashDistanceTolerance.
            """)
            + e(" hashDistance: (") + decimalHashDistance
            + e("). hashDistanceTolerance: (") + decimalHashDistance
            + e("). Image hash of actual image: ") + binaryHash
            + e(". Image hash of expected image: ") + binaryHash
            + e(".")
        
        assertFails(failureDescriptionMatchesRegularExpression: errorRegex) {
            assertImageMatchesReference(imageName: imageName, tolerance: tolerance)
        }
    }
    
    private func image(named imageName: String) -> UIImage? {
        return UIImage(named: imageName, in: Bundle(for: TestCase.self), compatibleWith: nil)
    }
    
    private func comparator(tolerance: UInt8) -> SnapshotsComparator {
        return ImageHashCalculatorSnapshotsComparator(
            imageHashCalculator: DHashV0ImageHashCalculator(),
            hashDistanceTolerance: tolerance
        )
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
