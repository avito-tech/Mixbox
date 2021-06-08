import MixboxFoundation
import UIKit

public protocol ImageProvider: AnyObject {
    func image() throws -> UIImage
}
