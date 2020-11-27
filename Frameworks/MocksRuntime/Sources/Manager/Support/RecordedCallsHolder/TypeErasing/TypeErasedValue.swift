import MixboxFoundation

public final class TypeErasedValue {
    public let valueAsAny: Any
    
    public init(_ valueAsAny: Any) {
        self.valueAsAny = valueAsAny
    }
    
    public func value<T>() throws -> T {
        guard let value: T = valueAsAny as? T else {
            throw ErrorString(
                """
                Failed to get typed value from type erased value. \
                Expected type: \(T.self), actual type: \(type(of: valueAsAny)).
                """
            )
        }
        
        return value
    }
}
