#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class RandomBoolGenerator: Generator<Bool> {
    public init(randomNumberProvider: RandomNumberProvider) {
        super.init {
            randomNumberProvider.nextRandomNumber() % 2 == 1
        }
    }
}

#endif
