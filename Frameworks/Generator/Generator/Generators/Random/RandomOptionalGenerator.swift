public final class RandomOptionalGenerator<T>: Generator<T?> {
    public init(anyGenerator: AnyGenerator, isNoneGenerator: Generator<Bool>) {
        super.init {
            let isNone = try isNoneGenerator.generate()
            
            if isNone {
                return .none
            } else {
                return .some(try anyGenerator.generate() as T)
            }
        }
    }
}
