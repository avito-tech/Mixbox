#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

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

#endif
