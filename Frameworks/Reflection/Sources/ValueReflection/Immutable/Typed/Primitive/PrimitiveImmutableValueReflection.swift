public final class PrimitiveImmutableValueReflection: ImmutableValueReflection {
    public let type: Any.Type
    public let reflected: Any
    
    public init(
        type: Any.Type,
        reflected: Any)
    {
        self.type = type
        self.reflected = reflected
    }
    
    public convenience init(
        reflected: Any)
    {
        self.init(
            type: Swift.type(of: reflected),
            reflected: reflected
        )
    }
}
