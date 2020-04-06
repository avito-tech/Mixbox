public final class EmptyArrayGenerator<T>: Generator<[T]> {
    public init() {
        super.init {
            []
        }
    }
}
