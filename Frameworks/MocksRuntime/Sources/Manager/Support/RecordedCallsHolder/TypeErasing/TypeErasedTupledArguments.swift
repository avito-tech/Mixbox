import MixboxFoundation

public final class TypeErasedTupledArguments {
    public let typeErasedValue: TypeErasedValue
    
    public init(_ valueAsAny: Any) {
        self.typeErasedValue = TypeErasedValue(valueAsAny)
    }
    
    public func tupledArguments<T>() throws -> T {
        return try typeErasedValue.value()
    }
}
