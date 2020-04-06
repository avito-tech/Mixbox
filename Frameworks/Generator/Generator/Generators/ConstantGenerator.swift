public final class ConstantGenerator<T>: Generator<T> {
    public init(_ constant: T) {
        super.init {
            constant
        }
    }
}
