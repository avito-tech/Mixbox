import MixboxGenerators

public protocol GeneratorFacade: TestFailingGenerator {
    // Any generator used in this facade, contains registered stubs.
    // Can be used to share same stubs with other entities that use `AnyGenerator`.
    // This looks like a kludge and can be removed in the future or refactored.
    // TODO: Refactor.
    var anyGenerator: AnyGenerator { get }
    
    // Registers stub permanently
    func stub<T: RepresentableByFields>(
        configure: @escaping (TestFailingDynamicLookupConfigurator<T>) throws -> ())
}

extension GeneratorFacade {
    public func stub<T: RepresentableByFields>(
        type: T.Type = T.self,
        configure: @escaping (TestFailingDynamicLookupConfigurator<T>) throws -> ())
    {
        stub(configure: configure)
    }
}
