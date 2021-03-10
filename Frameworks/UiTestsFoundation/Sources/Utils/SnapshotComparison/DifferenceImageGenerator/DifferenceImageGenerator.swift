import UIKit

// TODO: Test with images of same and different sizes
public protocol DifferenceImageGenerator {
    func differenceImage(actualImage: UIImage, expectedImage: UIImage) -> UIImage?
}
