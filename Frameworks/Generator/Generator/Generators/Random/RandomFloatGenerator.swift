public final class RandomFloatGenerator<T: FloatingPoint>: Generator<T> {
    public init(randomNumberProvider: RandomNumberProvider, closedRange: ClosedRange<T>) {
        super.init {
            let multiplier = closedRange.upperBound - closedRange.lowerBound
            let ratio = T(randomNumberProvider.nextRandomNumber()) / T(UInt64.max)
            return closedRange.lowerBound + multiplier * ratio
        }
    }
}
