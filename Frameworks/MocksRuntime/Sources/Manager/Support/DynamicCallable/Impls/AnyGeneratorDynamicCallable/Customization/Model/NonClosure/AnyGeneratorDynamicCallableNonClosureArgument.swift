public final class AnyGeneratorDynamicCallableNonClosureArgument {
    public let name: String?
    public let label: String?
    public let type: Any.Type
    public let value: Any
    
    public init(
        name: String?,
        label: String?,
        type: Any.Type,
        value: Any)
    {
        self.name = name
        self.label = label
        self.type = type
        self.value = value
    }
}
