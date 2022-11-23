#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

public final class RandomSetGenerator<T: Hashable>: Generator<Set<T>> {
    public init(anyGenerator: AnyGenerator, lengthGenerator: Generator<Int>) {
        super.init {
            var set = Set<T>()
            
            let length = try lengthGenerator.generate()
            
            // It is not perfect, but it probably can generate something for most cases.
            // Of course it can't generate set of unique booleans of size 3.
            let attemptsToGenerateUniqueValue = length * 2
            
            for _ in 0..<attemptsToGenerateUniqueValue where set.count < length {
                set.insert(try anyGenerator.generate())
            }

            return set
        }
    }
}

#endif
