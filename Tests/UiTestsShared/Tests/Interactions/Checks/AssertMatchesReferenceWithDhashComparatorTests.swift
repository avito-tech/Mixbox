import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxUiKit
import XCTest

// TODO: Rename
final class AssertMatchesReferenceWithDhashComparatorTests: TestCase {
    override var reuseState: Bool {
        return false
    }
    
    override func precondition() {
        super.precondition()
        
        open(screen: pageObjects.screen)
        pageObjects.screen.waitUntilViewIsLoaded()
    }
    
    func test___image_with_different_resolution___match() {
        assertImageMatchesReference(
            imageName: "imagehash_cats/imagehash_cat_size",
            // TODO: Should match with 0 tolerance.
            //       There is probably a bug with layout on iPhone 7 iOS 11.3 / Xcode 10.1 / High Sierra / Emcee runner.
            //       I can't reproduce it with iPhone 7 iOS 11.3 / Xcode 10.2 / Mojave / Xcode runner.
            //       And I don't have reports on CI.
            // UPDATE: Same in Xcode 12.4 in 2021.
            exactTolerance: valuesByIosVersion()
                .since(MixboxIosVersions.Outdated.iOS11).value(10)
                .since(MixboxIosVersions.Outdated.iOS12).value(1)
                .since(MixboxIosVersions.Supported.iOS15).value(2)
        )
    }
    
    func test___image_overlapped_with_lots_of_text___doesnt_match_with_low_tolerance() {
        assertImageMatchesReference(
            imageName: "imagehash_cats/imagehash_cat_lots_of_text",
            exactTolerance: valuesByIosVersion()
                .since(MixboxIosVersions.Outdated.iOS11).value(20)
                .since(MixboxIosVersions.Outdated.iOS12).value(14)
                .since(MixboxIosVersions.Outdated.iOS13).value(15)
                .since(MixboxIosVersions.Supported.iOS14).value(14)
        )
    }
    
    func test___different_image___doesnt_match_with_low_tolerance() {
        assertImageMatchesReference(
            imageName: "imagehash_cats/imagehash_cat_not_cat",
            exactTolerance: valuesByIosVersion()
                .since(MixboxIosVersions.Outdated.iOS11).value(39)
                .since(MixboxIosVersions.Outdated.iOS12).value(41)
        )
    }
    
    // This function test boundary of tolerance (`exactTolerance`), tests that result is different
    // on different sides of that boundary.
    private func assertImageMatchesReference(
        imageName: String,
        exactTolerance: ValuesByIosVersion<UInt8>,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        let exactTolerance = exactTolerance.getValue()
        
        // TODO: This test is unstable for whatever reason.
        let accuracy: UInt8 = 2 // 0 - perfect accuracy
        
        assertImageMatchesReference(
            imageName: imageName,
            tolerance: max(64, exactTolerance + accuracy),
            file: file,
            line: line
        )
        
        let toleranceDecrementToMakeAssertionFail = 1 + accuracy
        if exactTolerance >= toleranceDecrementToMakeAssertionFail {
            assertImageDoesntMatchReference(
                imageName: imageName,
                tolerance: min(0, exactTolerance - toleranceDecrementToMakeAssertionFail),
                file: file,
                line: line
            )
        }
    }
    
    private func assertImageMatchesReference(
        imageName: String,
        tolerance: UInt8,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        pageObjects.screen.catView.withoutTimeout.assertMatchesReference(
            image: image(name: imageName),
            comparator: comparator(tolerance: tolerance),
            file: file,
            line: line
        )
    }
    
    private func assertImageDoesntMatchReference(
        imageName: String,
        tolerance: UInt8,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
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
        
        assertFails(failureDescriptionMatchesRegularExpression: errorRegex, fileOfThisAssertion: file, lineOfThisAssertion: line) {
            assertImageMatchesReference(imageName: imageName, tolerance: tolerance, file: file, line: line)
        }
    }
    
    private func comparator(tolerance: UInt8) -> SnapshotsComparator {
        return ImageHashCalculatorSnapshotsComparator(
            imageHashCalculator: DHashImageHashCalculator(),
            hashDistanceTolerance: tolerance,
            shouldIgnoreTransparency: true
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
