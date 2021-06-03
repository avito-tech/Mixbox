import UIKit

public final class ImageHashCalculatorSnapshotsComparator: SnapshotsComparator {
    private let imageHashCalculator: ImageHashCalculator
    private let hashDistanceTolerance: UInt8
    private let shouldIgnoreTransparency: Bool
    
    public init(
        imageHashCalculator: ImageHashCalculator,
        hashDistanceTolerance: UInt8,
        shouldIgnoreTransparency: Bool)
    {
        self.imageHashCalculator = imageHashCalculator
        self.hashDistanceTolerance = hashDistanceTolerance
        self.shouldIgnoreTransparency = shouldIgnoreTransparency
    }
    
    public func compare(actualImage: UIImage, expectedImage: UIImage) -> SnapshotsComparisonResult {
        return ComparisonContext(
            imageHashCalculator: imageHashCalculator,
            hashDistanceTolerance: hashDistanceTolerance,
            actualImage: actualImage,
            expectedImage: expectedImage,
            imagesForHashingProvider: ImagesForHashingProvider(
                shouldIgnoreTransparency: shouldIgnoreTransparency
            )
        ).compare()
    }
}
