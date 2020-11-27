public final class TypeErasedReturnValue {
    public let typeErasedValue: TypeErasedValue
    
    public init(_ valueAsAny: Any) {
        self.typeErasedValue = TypeErasedValue(valueAsAny)
    }
    
    public func returnValue<T>() throws -> T {
        return try typeErasedValue.value()
    }
}
