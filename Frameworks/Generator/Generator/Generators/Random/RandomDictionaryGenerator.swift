public final class RandomDictionaryGenerator<T: Hashable, U>: Generator<[T: U]> {
    public init(anyGenerator: AnyGenerator, lengthGenerator: Generator<Int>) {
        super.init {
            var dictionary = [T: U]()
            
            let length = try lengthGenerator.generate()
            for _ in 0..<length {
                dictionary[try anyGenerator.generate()] = try anyGenerator.generate()
            }

            return dictionary
        }
    }
}
