#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

// Provides @dynamicMemberLookup access to dictionary with fields from T.
//
// Example:
//
//      struct MyObject {
//          let x: Int
//      }
//
//      let map: DynamicLookupGeneratorSelection<MyObject> = ...
//
//      try map.x.generate()
//
public class GeneratorByKeyPath<T> {
    public typealias GeneratedType = T
    
    private var generators: [PartialKeyPath<T>: Any] = [:]
    private let anyGenerator: AnyGenerator
    
    public init(anyGenerator: AnyGenerator) {
        self.anyGenerator = anyGenerator
    }
    
    public subscript<V>(keyPath: KeyPath<T, V>) -> Generator<V> {
        get {
            if let untypedGenerator = generators[keyPath] {
                if let typedGenerator = untypedGenerator as? Generator<V> {
                    return typedGenerator
                } else {
                    assertionFailure(
                        """
                        \(untypedGenerator) was stored for keyPath \(keyPath) of type \(V.self), \
                        expected: \(Generator<V>.self)
                        """
                    )
                    
                    // Fallback:
                    
                    return Generator<V> { [anyGenerator] in
                        try anyGenerator.generate() as V
                    }
                }
            } else {
                return Generator<V> { [anyGenerator] in
                    try anyGenerator.generate() as V
                }
            }
        }
        set {
            generators[keyPath] = newValue
        }
    }
}

#endif
