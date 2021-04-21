public final class SubstructureFieldBuilderCallImplementation<Structure, Substructure>: FieldBuilderCallImplementation {
    public typealias Structure = Substructure
    public typealias Result = Structure
    
    private let getSubstructure: () -> Substructure
    private let getResult: (Substructure) -> Result
    
    public init<T>(
        structure: T,
        getSubstructure: @escaping (T) -> Substructure,
        getResult: @escaping (T, Substructure) -> Result)
    {
        self.getSubstructure = {
            getSubstructure(structure)
        }
        self.getResult = {
            getResult(structure, $0)
        }
    }
    
    public func call<Field>(
        keyPath: WritableKeyPath<Substructure, Field>,
        field: Field)
        -> Result
    {
        var substructure = getSubstructure()
        substructure[keyPath: keyPath] = field
        return getResult(substructure)
    }
}
