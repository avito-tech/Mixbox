#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class EmptyOptionalGenerator<T>: Generator<T?> {
    public init() {
        super.init {
            nil
        }
    }
}

#endif
