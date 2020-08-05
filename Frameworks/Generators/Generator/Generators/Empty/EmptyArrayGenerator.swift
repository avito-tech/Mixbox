#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class EmptyArrayGenerator<T>: Generator<[T]> {
    public init() {
        super.init {
            []
        }
    }
}

#endif
