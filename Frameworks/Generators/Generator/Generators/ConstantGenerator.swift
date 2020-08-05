#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class ConstantGenerator<T>: Generator<T> {
    public init(_ constant: T) {
        super.init {
            constant
        }
    }
}

#endif
