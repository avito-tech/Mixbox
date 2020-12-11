public final class EscapingClosureArgumentValue {
    public let value: Any
    public let reflection: ClosureArgumentValueReflection
    
    public init(
        value: Any,
        reflection: ClosureArgumentValueReflection)
    {
        self.value = value
        self.reflection = reflection
    }
}
