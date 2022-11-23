#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

public final class RandomBoolGenerator: Generator<Bool> {
    public init(randomNumberProvider: RandomNumberProvider) {
        super.init {
            randomNumberProvider.nextRandomNumber() % 2 == 1
        }
    }
}

#endif
