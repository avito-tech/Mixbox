import UIKit
import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxFoundation
import XCTest

final class ImageHashCalculatorSnapshotsComparatorTests: BaseSnapshotsComparatorTestCase {
    private var hashDistanceTolerance: UInt8 = 10
    private var cornerCaseHashDistanceTolerances: [UInt8] = [0, 10, 64]
    
    override var comparator: SnapshotsComparator {
        return ImageHashCalculatorSnapshotsComparator(
            imageHashCalculator: DHashV0ImageHashCalculator(),
            hashDistanceTolerance: hashDistanceTolerance
        )
    }
    
    func test___compare___returns_error___if_hashDistanceTolerance_is_not_within_closed_range_from_0_to_64() {
        let dotImage = UnavoidableFailure.doOrFail {
            try UIImage.image(width: 1, height: 1, color: UIColor.red.cgColor)
        }
        let emptyImage = UIImage()
        
        let compareSimilarImages = {
            self.comparator.compare(actualImage: dotImage, expectedImage: dotImage)
        }
        let compareEmptyImages = {
            self.comparator.compare(actualImage: emptyImage, expectedImage: emptyImage)
        }
        
        for hashDistanceTolerance in UInt8.min...64 {
            self.hashDistanceTolerance = hashDistanceTolerance
            assertSimilar(snapshotsComparisonResult: compareSimilarImages())
            assertSimilar(snapshotsComparisonResult: compareEmptyImages())
        }

        for hashDistanceTolerance in 65...UInt8.max {
            self.hashDistanceTolerance = hashDistanceTolerance
            assertDifferent(snapshotsComparisonResult: compareSimilarImages()) { (snapshotsDifferenceDescription, _, _) in
                XCTAssertEqual(
                    snapshotsDifferenceDescription.message,
                    "hashDistanceTolerance (the argument of init of ImageHashCalculatorSnapshotsComparator) is set to an inappropriate value \(hashDistanceTolerance), it should be >= 0 and <= 64"
                )
            }
            // This should fail either (I know that empty images are always similar regardless
            // of any settings of comparison, however, it's better to notify developer that he
            // made a mistake anyway):
            assertDifferent(snapshotsComparisonResult: compareEmptyImages())
        }
    }
    
    func test___compare___tells_images_are_similar___if_only_unrelated_image_settings_are_different_or_similar() {
        for hashDistanceTolerance in cornerCaseHashDistanceTolerances {
            self.hashDistanceTolerance = hashDistanceTolerance
            check___compare___tells_images_are_similar___if_only_unrelated_image_settings_are_different_or_similar()
        }
    }
    
    func test___compare___tells_images_are_similar___if_sizes_are_different_for_visually_similar_images() {
        compareImages(
            lhsSize: CGSize(width: 1, height: 2),
            rhsSize: CGSize(width: 3, height: 5),
            resultHandler: { result in
                assertSimilar(snapshotsComparisonResult: result) { _ in
                    """
                    Images of different size are NOT expected to be different if they \
                    are visually similar if ImageHashCalculatorSnapshotsComparator is used, \
                    because it should be tolerant to difference in sizes
                    """
                }
            }
        )
    }
    
    func test___compare___tells_images_are_similar___if_images_have_little_difference_in_color() {
        compareImages(
            lhsColor: UIColor(red: 2, green: 5, blue: 11, alpha: 241).cgColor,
            rhsColor: UIColor(red: 3, green: 7, blue: 13, alpha: 251).cgColor,
            resultHandler: { result in
                assertSimilar(snapshotsComparisonResult: result) { _ in
                    """
                    Images of slightly different colors are NOT expected to be different if they \
                    are visually similar if ImageHashCalculatorSnapshotsComparator is used, \
                    because it should be tolerant to small difference in colors
                    """
                }
            }
        )
    }
    
    func test___compare___tells_images_are_similar___if_images_have_significant_difference_in_color() {
        let resultHandler: (SnapshotsComparisonResult) -> () = { result in
            self.assertSimilar(snapshotsComparisonResult: result) { _ in
                """
                Images of different colors (unfortunately?) are similar from a point of view \
                of ImageHashCalculatorSnapshotsComparator. This is only the case if those images \
                lack features (like monotone images).
                """
            }
        }
        
        compareImages(
            lhsColor: UIColor.yellow.cgColor,
            rhsColor: UIColor.blue.cgColor,
            resultHandler: resultHandler
        )
        
        compareImages(
            lhsColor: UIColor.white.cgColor,
            rhsColor: UIColor.black.cgColor,
            resultHandler: resultHandler
        )
    }
    
    func disabled_test___compare___tells_images_are_similar___if_only_difference_is_transparency_of_pixels() {
        continueAfterFailure = true
        
        iterateCombinations { isTransparent0, isTransparent1, isTransparent2, isTransparent3 in
            assertDoesntThrow {
                let actualImage = imageWithShape(
                    backgroundColor: color(isTransparent0),
                    foregroundColor: color(isTransparent1)
                )
                let expectedImage = imageWithShape(
                    backgroundColor: color(isTransparent2),
                    foregroundColor: color(isTransparent3)
                )
                let result = comparator.compare(
                    actualImage: actualImage,
                    expectedImage: expectedImage
                )
                
                assertSimilar(snapshotsComparisonResult: result) { _ in
                    """
                    Transparent pixels should be ignored when images are compared.

                    Current combination: \([isTransparent0, isTransparent1, isTransparent2, isTransparent3])
                    """
                }
            }
        }
    }
    
    // Draws circle with `foregroundColor` on a background with `backgroundColor`.
    // Both circle and background can be transparent.
    private func imageWithShape(backgroundColor: CGColor, foregroundColor: CGColor) -> UIImage {
        UnavoidableFailure.doOrFail {
            try UIImage.image(width: 100, height: 100) { (context, frame) in
                var smallerFrame = frame.mb_scaleAndTranslate(amount: 0.5)
                smallerFrame.mb_center = frame.mb_center
                
                context.setFillColor(backgroundColor)
                context.fill(frame)
                
                context.saveGState()
                context.setBlendMode(.copy)
                context.setFillColor(foregroundColor)
                context.fillEllipse(in: smallerFrame)
                context.restoreGState()
            }
        }
    }
    
    private func iterateCombinations(body: (Bool, Bool, Bool, Bool) -> ()) {
        let booleans = [false, true]
        
        for x in booleans {
            for y in booleans {
                for z in booleans {
                    for w in booleans {
                        body(x, y, z, w)
                    }
                }
            }
        }
    }
    
    private func color(_ isTransparent: Bool) -> CGColor {
        let transparentColor = UIColor.clear.cgColor
        let opaqueColor = UIColor.red.cgColor
        
        return isTransparent
            ? transparentColor
            : opaqueColor
    }
}
