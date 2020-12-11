import MixboxGenerators

public final class TypeErasedAnyGeneratorSpecializationsBuilder {
    public private(set) var specializations: [HashableType: TypeErasedAnyGeneratorSpecialization] = [:]
    
    public init() {
    }
    
    // Note that value is completely ignored.
    public func add<T>(_: T.Type) -> Self {
        specializations[HashableType(type: T.self)] = TypeErasedAnyGeneratorSpecializationImpl<T>()
        
        return self
    }
}
