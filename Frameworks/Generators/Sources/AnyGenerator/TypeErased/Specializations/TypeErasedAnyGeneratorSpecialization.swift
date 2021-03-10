#if MIXBOX_ENABLE_IN_APP_SERVICES

// Is responsible for specialization of generic `generate<T>()` function
// of `AnyGenerator` for a single type (`T`).
//
// See `TypeErasedAnyGenerator` for explanation.
//
public protocol TypeErasedAnyGeneratorSpecialization {
    func generate(anyGenerator: AnyGenerator) throws -> Any
}

#endif
