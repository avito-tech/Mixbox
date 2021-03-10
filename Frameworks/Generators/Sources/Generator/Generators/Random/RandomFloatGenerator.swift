#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class RandomFloatGenerator<T: FloatingPoint>: Generator<T> {
    // TODO: Numbers that are more random? Support different distributions?
    // Like here: https://en.cppreference.com/w/cpp/numeric/random/uniform_real_distribution
    public convenience init(randomNumberProvider: RandomNumberProvider) {
        self.init(randomNumberProvider: randomNumberProvider, closedRange: -1_000_000_000...1_000_000_000)
    }
    
    public init(randomNumberProvider: RandomNumberProvider, closedRange: ClosedRange<T>) {
        super.init {
            let multiplier = closedRange.upperBound - closedRange.lowerBound
            let ratio = T(randomNumberProvider.nextRandomNumber()) / T(UInt64.max)
            return closedRange.lowerBound + multiplier * ratio
        }
    }
}

#endif
