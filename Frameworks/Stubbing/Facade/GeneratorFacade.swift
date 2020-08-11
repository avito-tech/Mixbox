import MixboxGenerators

public protocol GeneratorFacade {
    // Any generator used in this facade, contains registered stubs.
    // Can be used to share same stubs with other entities that use `AnyGenerator`.
    // This looks like a kludge and can be removed in the future or refactored.
    // TODO: Refactor.
    var anyGenerator: AnyGenerator { get }
    
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

extension GeneratorFacade {
    public func stub<T>(
        type: T.Type = T.self,
        configure: @escaping (TestFailingDynamicLookupGenerator<T>) throws -> ())
    {
        stub(configure: configure)
    }
}
