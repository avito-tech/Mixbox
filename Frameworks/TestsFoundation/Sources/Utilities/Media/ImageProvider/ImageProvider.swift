import MixboxFoundation
import UIKit

public protocol ImageProvider: class {
    func image() throws -> UIImage
}
