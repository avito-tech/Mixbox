import UIKit

public final class ImageHashCalculatorSnapshotsComparator: SnapshotsComparator {
    private let imageHashCalculator: ImageHashCalculator
    private let hashDistanceTolerance: UInt8
    
    public init(imageHashCalculator: ImageHashCalculator, hashDistanceTolerance: UInt8) {
        self.imageHashCalculator = imageHashCalculator
        self.hashDistanceTolerance = hashDistanceTolerance
    }
    
    // swiftlint:disable:next function_body_length
    public func compare(actualImage: UIImage, expectedImage: UIImage) -> SnapshotsComparisonResult {
        let maxHashDistance = UInt8(Int64.bitWidth)
        
        let hashDistanceRange = ClosedRange(uncheckedBounds: (lower: 0, upper: maxHashDistance))
        
        guard hashDistanceRange.contains(hashDistanceTolerance) else {
            return ImageHashCalculatorSnapshotsComparator.valueIsNotInRangeResult(
                value: hashDistanceTolerance,
                valueName: "hashDistanceTolerance (the argument of init of this class, \(type(of: self)))",
                range: hashDistanceRange,
                actualImage: actualImage,
                expectedImage: expectedImage
            )
        }
        
        if actualImage.size == .zero && expectedImage.size == .zero {
            // This is unlkely to be expected case in tests (and probably person should
            // be notified that unexpected situation happened), however, you can't say
            // that images in this case aren't visually similar, so we just return
            // that they are similar and do nothing else.
            return .similar
        }
        
        let actualHash: UInt64
        
        do {
            actualHash = try imageHashCalculator.imageHash(image: actualImage)
        } catch {
            return Self.failedToGetHashResult(
                error: error,
                imageDescription: "actual image",
                actualImage: actualImage,
                expectedImage: expectedImage
            )
        }
        
        let expectedHash: UInt64
        
        do {
            expectedHash = try imageHashCalculator.imageHash(image: expectedImage)
        } catch {
            return Self.failedToGetHashResult(
                error: error,
                imageDescription: "expected image",
                actualImage: actualImage,
                expectedImage: expectedImage
            )
        }
        
        let hashDistance = imageHashCalculator.hashDistance(
            lhsHash: actualHash,
            rhsHash: expectedHash
        )
        
        guard hashDistanceRange.contains(hashDistance) else {
            return ImageHashCalculatorSnapshotsComparator.valueIsNotInRangeResult(
                value: hashDistanceTolerance,
                valueName: "hashDistance (the value provided by \(type(of: imageHashCalculator)))",
                range: hashDistanceRange,
                actualImage: actualImage,
                expectedImage: expectedImage
            )
        }
        
        if hashDistance <= hashDistanceTolerance {
            return .similar
        } else {
            let percentageOfMatching = Double(maxHashDistance - hashDistance) / Double(maxHashDistance - hashDistanceTolerance)
            
            return .different(
                LazySnapshotsDifferenceDescription(
                    percentageOfMatching: percentageOfMatching,
                    messageFactory: { [hashDistanceTolerance] in
                        """
                        Actual hashDistance is below hashDistanceTolerance. \
                        hashDistance: (\(hashDistance)). \
                        hashDistanceTolerance: (\(hashDistanceTolerance)). \
                        Image hash of actual image: \(ImageHashCalculatorSnapshotsComparator.bitPatternString(actualHash)). \
                        Image hash of expected image: \(ImageHashCalculatorSnapshotsComparator.bitPatternString(expectedHash)).
                        """
                    },
                    actualImage: actualImage,
                    expectedImage: expectedImage
                )
            )
        }
    }
    
    private static func valueIsNotInRangeResult<T>(
        value: T,
        valueName: String,
        range: ClosedRange<T>,
        actualImage: UIImage,
        expectedImage: UIImage)
        -> SnapshotsComparisonResult
    {
        return .different(
            LazySnapshotsDifferenceDescription(
                percentageOfMatching: 0,
                messageFactory: {
                    """
                    \(valueName) is set to an inappropriate value \(value), \
                    it should be >= \(range.lowerBound) and <= \(range.upperBound)
                    """
                },
                actualImage: actualImage,
                expectedImage: expectedImage
            )
        )
    }
    
    private static func failedToGetHashResult(
        error: Error,
        imageDescription: String,
        actualImage: UIImage,
        expectedImage: UIImage)
        -> SnapshotsComparisonResult
    {
        return .different(
            LazySnapshotsDifferenceDescription(
                percentageOfMatching: 0,
                messageFactory: {
                    """
                    Failed to get hash of the "\(imageDescription)". Error: \(error)
                    """
                },
                actualImage: actualImage,
                expectedImage: expectedImage
            )
        )
    }
    
    private static func bitPatternString<T>(_ number: T) -> String where T: FixedWidthInteger {
        let binaryString = String(number, radix: 2)
        
        return binaryString.padding(toLength: T.bitWidth, withPad: "0", startingAt: 0)
    }
}
