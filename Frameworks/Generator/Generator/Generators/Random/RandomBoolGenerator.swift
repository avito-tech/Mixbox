public final class RandomBoolGenerator: Generator<Bool> {
    public init(randomNumberProvider: RandomNumberProvider) {
        super.init {
            randomNumberProvider.nextRandomNumber() % 2 == 1
        }
    }
}
