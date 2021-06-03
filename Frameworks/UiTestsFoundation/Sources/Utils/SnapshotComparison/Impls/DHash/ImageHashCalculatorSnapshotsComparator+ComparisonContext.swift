import UIKit

// Class is made to store some constants and allow not to
// pass them between functions in `ImageHashCalculatorSnapshotsComparator`,
// this made it possible to split one big function into smaller ones without much boilerplate.
// Class is stateless.
extension ImageHashCalculatorSnapshotsComparator {
    final class ComparisonContext {
        private let imageHashCalculator: ImageHashCalculator
        private let hashDistanceTolerance: UInt8
        private let actualImage: UIImage
        private let expectedImage: UIImage
        private let maxHashDistance = UInt8(Int64.bitWidth)
        private let hashDistanceRange: ClosedRange<UInt8>
        private let imagesForHashingProvider: ImagesForHashingProvider
        
        init(
            imageHashCalculator: ImageHashCalculator,
            hashDistanceTolerance: UInt8,
            actualImage: UIImage,
            expectedImage: UIImage,
            imagesForHashingProvider: ImagesForHashingProvider)
        {
            self.imageHashCalculator = imageHashCalculator
            self.hashDistanceTolerance = hashDistanceTolerance
            self.actualImage = actualImage
            self.expectedImage = expectedImage
            self.imagesForHashingProvider = imagesForHashingProvider
            
            hashDistanceRange = ClosedRange(
                uncheckedBounds: (
                    lower: 0,
                    upper: maxHashDistance
                )
            )
        }
        
        func compare() -> SnapshotsComparisonResult {
            do {
                try compareAndThrowIfDifferent()
                
                return .similar
            } catch let error as ComparisonError {
                return .different(error.snapshotsDifferenceDescription)
            } catch {
                return .different(
                    snapshotsDifferenceDescription { "\(error)" }
                )
            }
        }
        
        func compareAndThrowIfDifferent() throws {
            try validateHashDistanceTolerance()
            
            if actualImage.size == .zero && expectedImage.size == .zero {
                // This is unlkely to be expected case in tests (and probably person should
                // be notified that unexpected situation happened), however, you can't say
                // that images in this case aren't visually similar, so we just return
                // that they are similar and do nothing else.
                return
            }
            
            let imagesForHashing = try self.imagesForHashing()
            
            let hashDifference = try self.hashDifference(
                imagesForHashing: imagesForHashing
            )
            
            if hashDifference.distance > hashDistanceTolerance {
                let percentageOfMatching = Double(maxHashDistance - hashDifference.distance)
                    / Double(maxHashDistance - hashDistanceTolerance)
                
                throw comparisonError(
                    percentageOfMatching: percentageOfMatching,
                    messageFactory: { [hashDistanceTolerance] in
                        """
                        Actual hashDistance is below hashDistanceTolerance. \
                        hashDistance: (\(hashDifference.distance)). \
                        hashDistanceTolerance: (\(hashDistanceTolerance)). \
                        Image hash of actual image: \(Self.bitPatternString(hashDifference.actualHash)). \
                        Image hash of expected image: \(Self.bitPatternString(hashDifference.expectedHash)).
                        """
                    }
                )
            }
        }
        
        private func validateHashDistanceTolerance() throws {
            if !hashDistanceRange.contains(hashDistanceTolerance) {
                throw valueIsNotInRangeError(
                    value: hashDistanceTolerance,
                    valueName: "hashDistanceTolerance (the argument of init of \(ImageHashCalculatorSnapshotsComparator.self))",
                    range: hashDistanceRange
                )
            }
        }
        
        private func imagesForHashing() throws -> ImagesForHashing {
            return try imagesForHashingProvider.imagesForHashing(
                actualImage: actualImage,
                expectedImage: expectedImage
            )
        }
        
        private func hashDifference(imagesForHashing: ImagesForHashing) throws -> HashDifference {
            let actualHash = try hash(
                image: imagesForHashing.actualImage,
                imageDescription: "actual image"
            )
            
            let expectedHash = try hash(
                image: imagesForHashing.expectedImage,
                imageDescription: "expected image"
            )
            
            let hashDistance = imageHashCalculator.hashDistance(
                lhsHash: actualHash,
                rhsHash: expectedHash
            )
            
            if !hashDistanceRange.contains(hashDistance) {
                throw valueIsNotInRangeError(
                    value: hashDistanceTolerance,
                    valueName: "hashDistance (the value provided by \(type(of: imageHashCalculator)))",
                    range: hashDistanceRange
                )
            }
            
            return HashDifference(
                distance: hashDistance,
                actualHash: actualHash,
                expectedHash: expectedHash
            )
        }
        
        private func hash(image: UIImage, imageDescription: String) throws -> UInt64 {
            do {
                return try imageHashCalculator.imageHash(image: image)
            } catch {
                throw failedToGetHashError(
                    error: error,
                    imageDescription: "expected image"
                )
            }
        }
        
        private func valueIsNotInRangeError<T>(
            value: T,
            valueName: String,
            range: ClosedRange<T>)
            -> ComparisonError
        {
            return comparisonError {
                """
                \(valueName) is set to an inappropriate value \(value), \
                it should be >= \(range.lowerBound) and <= \(range.upperBound)
                """
            }
        }
        
        private func failedToGetHashError(
            error: Error,
            imageDescription: String)
            -> ComparisonError
        {
            return comparisonError {
                """
                Failed to get hash of the "\(imageDescription)". Error: \(error)
                """
            }
        }
        
        private func comparisonError(
            percentageOfMatching: Double = 0,
            messageFactory: @escaping () -> String)
            -> ComparisonError
        {
            return ComparisonError(
                snapshotsDifferenceDescription: snapshotsDifferenceDescription(
                    percentageOfMatching: percentageOfMatching,
                    messageFactory: messageFactory
                )
            )
        }
        
        private func snapshotsDifferenceDescription(
            percentageOfMatching: Double = 0,
            messageFactory: @escaping () -> String)
            -> SnapshotsDifferenceDescription
        {
            return LazySnapshotsDifferenceDescription(
                percentageOfMatching: percentageOfMatching,
                messageFactory: messageFactory,
                actualImage: actualImage,
                expectedImage: expectedImage
            )
        }
        
        private static func bitPatternString<T>(_ number: T) -> String where T: FixedWidthInteger {
            let binaryString = String(number, radix: 2)
            
            return binaryString.padding(toLength: T.bitWidth, withPad: "0", startingAt: 0)
        }
    }
}
