public final class DictionaryImmutableValueReflectionPair {
    public let key: TypedImmutableValueReflection
    public let value: TypedImmutableValueReflection
    
    public init(
        key: TypedImmutableValueReflection,
        value: TypedImmutableValueReflection)
    {
        self.key = key
        self.value = value
    }
}
