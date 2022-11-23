#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

// Is responsible for specialization of generic `generate<T>()` function
// of `AnyGenerator` for a single type (`T`).
//
// See `TypeErasedAnyGenerator` for explanation.
//
public protocol TypeErasedAnyGeneratorSpecialization {
    func generate(anyGenerator: AnyGenerator) throws -> Any
}

#endif
