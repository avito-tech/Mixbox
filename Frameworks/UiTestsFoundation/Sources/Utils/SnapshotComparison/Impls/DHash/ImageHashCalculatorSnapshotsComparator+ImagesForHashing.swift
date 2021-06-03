import UIKit

extension ImageHashCalculatorSnapshotsComparator {
    final class ImagesForHashing {
        let actualImage: UIImage
        let expectedImage: UIImage
        
        init(
            actualImage: UIImage,
            expectedImage: UIImage)
        {
            self.actualImage = actualImage
            self.expectedImage = expectedImage
        }
    }
}
