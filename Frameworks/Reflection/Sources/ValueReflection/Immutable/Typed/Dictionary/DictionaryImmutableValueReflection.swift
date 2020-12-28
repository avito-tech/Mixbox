public final class DictionaryImmutableValueReflection:
    ImmutableValueReflection,
    ReflectableWithReflector
{
    public let type: Any.Type
    public let pairs: [DictionaryImmutableValueReflectionPair]
    
    public init(
        type: Any.Type,
        pairs: [DictionaryImmutableValueReflectionPair])
    {
        self.type = type
        self.pairs = pairs
    }
    
    public static func reflect(reflector: Reflector) -> DictionaryImmutableValueReflection {
        return DictionaryImmutableValueReflection(
            type: reflector.mirror.subjectType,
            pairs: reflector.mirror.children.compactMap { child in
                let pair = Mirror(reflecting: child.value).children
                
                let iterator = pair.makeIterator()
                
                guard let keyMirrorChild = iterator.next(), let valueMirrorChild = iterator.next(), iterator.next() == nil else {
                    return nil
                }
                
                return DictionaryImmutableValueReflectionPair(
                    key: reflector.nestedValueReflection(
                        value: keyMirrorChild.value
                    ),
                    value: reflector.nestedValueReflection(
                        value: valueMirrorChild.value
                    )
                )
            }
        )
    }
}
