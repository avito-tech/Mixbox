public final class DictionaryImmutableValueReflection: ImmutableValueReflection, ReflectableWithMirror {
    public let type: Any.Type
    public let pairs: [DictionaryImmutableValueReflectionPair]
    
    public init(
        type: Any.Type,
        pairs: [DictionaryImmutableValueReflectionPair])
    {
        self.type = type
        self.pairs = pairs
    }
    
    public static func reflect(mirror: Mirror) -> DictionaryImmutableValueReflection {
        return DictionaryImmutableValueReflection(
            type: mirror.subjectType,
            pairs: mirror.children.compactMap { child in
                let pair = Mirror(reflecting: child.value).children
                
                let iterator = pair.makeIterator()
                
                guard let keyMirror = iterator.next(), let valueMirror = iterator.next(), iterator.next() == nil else {
                    return nil
                }
                
                return DictionaryImmutableValueReflectionPair(
                    key: TypedImmutableValueReflection.reflect(
                        reflected: keyMirror.value
                    ),
                    value: TypedImmutableValueReflection.reflect(
                        reflected: valueMirror.value
                    )
                )
            }
        )
    }
}
