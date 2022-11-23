#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

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

#endif
