// TODO: Try to remove constraint to GeneratableByFields
public protocol GeneratorFacade {
    // Registers stub permanently
    func stub<T: GeneratableByFields>(
        configure: @escaping (TestFailingDynamicLookupGenerator<T>) throws -> ())
    
    // Generates value
    func generate<T: GeneratableByFields>() -> T
    
    // Generates value with temporary stub
    func generate<T: GeneratableByFields>(
        configure: @escaping (TestFailingDynamicLookupGenerator<T>) throws -> ())
        -> T
    
}
