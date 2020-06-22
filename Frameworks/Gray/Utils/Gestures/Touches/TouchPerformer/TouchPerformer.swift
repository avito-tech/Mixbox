import MixboxFoundation
import UIKit
import Foundation


public protocol TouchPerformer: class {
    func touch(
        touchPaths: [[CGPoint]],
        duration: TimeInterval,
        isExpendable: Bool)
        throws
}
