public final class FieldBuilderProperty<T: FieldBuilderCallImplementation, Field> {
    private let keyPath: WritableKeyPath<T.Structure, Field>
    private let callImplementation: T
    
    public init(
        keyPath: WritableKeyPath<T.Structure, Field>,
        callImplementation: T)
    {
        self.keyPath = keyPath
        self.callImplementation = callImplementation
    }
    
    public func callAsFunction(_ field: Field) -> T.Result {
        return callImplementation.call(keyPath: keyPath, field: field)
    }
}
