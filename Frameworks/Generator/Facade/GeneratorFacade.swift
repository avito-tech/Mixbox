public protocol GeneratorFacade {
    // Registers stub permanently
    func stub<T>(
        configure: @escaping (TestFailingDynamicLookupGenerator<T>) throws -> ())
    
    // Generates value
    func generate<T>() -> T
    
    // Generates value with temporary stub
    func generate<T>(
        configure: @escaping (TestFailingDynamicLookupGenerator<T>) throws -> ())
        -> T
    
}
