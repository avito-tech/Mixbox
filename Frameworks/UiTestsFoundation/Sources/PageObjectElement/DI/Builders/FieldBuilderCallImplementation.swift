public protocol FieldBuilderCallImplementation {
    associatedtype Structure
    associatedtype Result
    
    func call<Field>(
        keyPath: WritableKeyPath<Structure, Field>,
        field: Field)
        -> Result
}
