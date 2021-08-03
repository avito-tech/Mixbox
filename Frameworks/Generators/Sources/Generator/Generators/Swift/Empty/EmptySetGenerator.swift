#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class EmptySetGenerator<T: Hashable>: Generator<Set<T>> {
    public init() {
        super.init {
            []
        }
    }
}

#endif
