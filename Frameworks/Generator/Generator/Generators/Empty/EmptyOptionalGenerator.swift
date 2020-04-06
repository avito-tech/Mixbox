public final class EmptyOptionalGenerator<T>: Generator<T?> {
    public init() {
        super.init {
            nil
        }
    }
}
