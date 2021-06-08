import UIKit

public protocol SnapshotsComparator: AnyObject {
    func compare(actualImage: UIImage, expectedImage: UIImage) -> SnapshotsComparisonResult
}
