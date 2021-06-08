import UIKit

public protocol SnapshotsDifferenceDescription: AnyObject {
    var percentageOfMatching: Double { get }
    var message: String { get }
    var actualImage: UIImage { get }
    var expectedImage: UIImage { get }
}
