#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class EmptyDictionaryGenerator<T: Hashable, U>: Generator<[T: U]> {
    public init() {
        super.init {
            [:]
        }
    }
}

#endif
