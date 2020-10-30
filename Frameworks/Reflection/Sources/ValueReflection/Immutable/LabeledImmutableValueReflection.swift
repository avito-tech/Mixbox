public final class LabeledImmutableValueReflection {
    public let label: String?
    public let value: TypedImmutableValueReflection
    
    public init(label: String?, value: TypedImmutableValueReflection) {
        self.label = label
        self.value = value
    }
}
