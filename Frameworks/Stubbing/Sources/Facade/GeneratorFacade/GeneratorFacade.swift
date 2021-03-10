import MixboxGenerators

public protocol GeneratorFacade: TestFailingGenerator {
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
