public final class RandomArrayGenerator<T>: Generator<[T]> {
    public init(anyGenerator: AnyGenerator, lengthGenerator: Generator<Int>) {
        super.init {
            var array = [T]()
            
            let length = try lengthGenerator.generate()
            for _ in 0..<length {
                array.append(try anyGenerator.generate())
            }

            return array
        }
    }
}
