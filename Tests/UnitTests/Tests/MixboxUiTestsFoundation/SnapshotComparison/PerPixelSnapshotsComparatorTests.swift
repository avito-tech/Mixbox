import UIKit
import MixboxUiTestsFoundation
import MixboxFoundation
import XCTest

final class PerPixelSnapshotsComparatorTests: BaseSnapshotsComparatorTestCase {
    override var comparator: SnapshotsComparator {
        return PerPixelSnapshotsComparator(
            tolerance: 0,
            forceUsingNonDiscretePercentageOfMatching: false
        )
    }
    
    func test___compare___tells_images_are_similar___if_only_unrelated_image_settings_are_different_or_similar() {
        check___compare___tells_images_are_similar___if_only_unrelated_image_settings_are_different_or_similar()
    }
    
    func test___compare___tells_images_are_different___if_sizes_are_different() {
        compareImages(
            lhsSize: CGSize(width: 1, height: 2),
            rhsSize: CGSize(width: 3, height: 5),
            resultHandler: { result in
                assertDifferent(snapshotsComparisonResult: result) { (snapshotsDifferenceDescription, _, _) in
                    XCTAssertEqual(
                        snapshotsDifferenceDescription.message,
                        """
                        Failed to compare images: Images have different frame: (0.0, 0.0, 1.0, 2.0) != (0.0, 0.0, 3.0, 5.0)
                        """
                    )
                    XCTAssertEqual(
                        snapshotsDifferenceDescription.percentageOfMatching,
                        0
                    )
                }
            }
        )
    }
    
    func test___compare___tells_images_are_different___if_pixels_are_different() {
        compareImages(
            lhsColor: UIColor(red: 5, green: 13, blue: 89, alpha: 233).cgColor,
            rhsColor: UIColor(red: 21, green: 34, blue: 55, alpha: 144).cgColor,
            resultHandler: { result in
                assertDifferent(snapshotsComparisonResult: result) { (snapshotsDifferenceDescription, _, _) in
                    XCTAssertEqual(
                        snapshotsDifferenceDescription.message,
                        """
                        Failed to compare images: Image has different pixels
                        """
                    )
                    XCTAssertEqual(
                        snapshotsDifferenceDescription.percentageOfMatching,
                        0
                    )
                }
            }
        )
    }
}
