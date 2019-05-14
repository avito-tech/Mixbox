public final class ImageHashCalculatorSnapshotsComparator: SnapshotsComparator {
    private let imageHashCalculator: ImageHashCalculator
    private let hashDistanceTolerance: UInt8
    
    public init(imageHashCalculator: ImageHashCalculator, hashDistanceTolerance: UInt8 = 10) {
        self.imageHashCalculator = imageHashCalculator
        self.hashDistanceTolerance = hashDistanceTolerance
    }
    
    public func equals(actual: UIImage, expected: UIImage) -> MatchingResult {
        let maxHashDistance = UInt8(Int64.bitWidth)
        
        let hashDistanceRange = ClosedRange(uncheckedBounds: (lower: 0, upper: maxHashDistance))
        
        guard hashDistanceRange.contains(hashDistanceTolerance) else {
            return valueIsNotInRangeResult(
                value: hashDistanceTolerance,
                valueName: "hashDistanceTolerance (the argument of init of this class, \(type(of: self)))",
                range: hashDistanceRange
            )
        }
        
        let actualHash = imageHashCalculator.imageHash(image: actual)
        let expectedHash = imageHashCalculator.imageHash(image: expected)
        
        let hashDistance = imageHashCalculator.hashDistance(
            lhsHash: actualHash,
            rhsHash: expectedHash
        )
        
        guard hashDistanceRange.contains(hashDistance) else {
            return valueIsNotInRangeResult(
                value: hashDistanceTolerance,
                valueName: "hashDistance (the value provided by \(type(of: imageHashCalculator)))",
                range: hashDistanceRange
            )
        }
        
        if hashDistance <= hashDistanceTolerance {
            return .match
        } else {
            let percentageOfMatching = Double(maxHashDistance - hashDistance) / Double(maxHashDistance - hashDistanceTolerance)
            
            return .partialMismatch(
                percentageOfMatching: percentageOfMatching,
                mismatchDescription: { [hashDistanceTolerance] in
                    """
                    Actual hashDistance is below hashDistanceTolerance. \
                    hashDistance: (\(hashDistance)). \
                    hashDistanceTolerance: (\(hashDistanceTolerance)). \
                    Image hash of actual image: \(bitPatternString(actualHash)). \
                    Image hash of expected image: \(bitPatternString(expectedHash)).
                    """
                }
            )
        }
    }
}

private func bitPatternString<T>(_ number: T) -> String where T: FixedWidthInteger {
    let binaryString = String(number, radix: 2)
    
    return binaryString.padding(toLength: T.bitWidth, withPad: "0", startingAt: 0)
}

private func valueIsNotInRangeResult<T>(
    value: T,
    valueName: String,
    range: ClosedRange<T>)
    -> MatchingResult
{
    return .exactMismatch(
        mismatchDescription: {
            """
            \(valueName) is set to an inappropriate value \(value), \
            it should be >= \(range.lowerBound) and <= \(range.upperBound)"
            """
    }
    )
}
