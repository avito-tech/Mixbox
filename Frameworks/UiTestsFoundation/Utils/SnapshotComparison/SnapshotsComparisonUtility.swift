import UIKit
import MixboxUiKit

// TODO: SRP, better interface
public protocol SnapshotsComparisonUtility {
    func compare(
        actual: UIImage,
        reference: UIImage,
        comparator: SnapshotsComparator)
        -> SnapshotsComparisonResult
    
    func compare(
        actual: UIImage,
        folder: String,
        file: String,
        comparator: SnapshotsComparator)
        -> SnapshotsComparisonResult
}
