public final class RandomIntegerGenerator<T: BinaryInteger>: Generator<T> {
    public init(randomNumberProvider: RandomNumberProvider) {
        super.init {
            T(
                truncatingIfNeeded: randomNumberProvider.nextRandomNumber()
            )
        }
    }
}
