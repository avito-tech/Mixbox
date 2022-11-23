#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

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

#endif
