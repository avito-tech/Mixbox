public final class EmptyDictionaryGenerator<T: Hashable, U>: Generator<[T: U]> {
    public init() {
        super.init {
            [:]
        }
    }
}
