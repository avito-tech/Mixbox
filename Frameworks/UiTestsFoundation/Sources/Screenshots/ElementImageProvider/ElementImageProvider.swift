import UIKit

public protocol ElementImageProvider {
    func elementImage(
        elementShanpshot: ElementSnapshot)
        throws
        -> UIImage
}
