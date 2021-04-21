public final class StructureFieldBuilderCallImplementation<Structure>: FieldBuilderCallImplementation {
    public typealias Structure = Structure
    public typealias Result = Structure
    
    private let structure: Structure
    
    public init(structure: Structure) {
        self.structure = structure
    }
    
    public func call<Field>(
        keyPath: WritableKeyPath<Structure, Field>,
        field: Field)
        -> Result
    {
        var structure = self.structure
        structure[keyPath: keyPath] = field
        return structure
    }
}
