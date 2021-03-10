import MixboxGenerators

public final class TestFailingObjectGeneratorImpl: TestFailingObjectGenerator {
    private let generator: TestFailingObjectGeneratorWithConfiguratorModification
    
    public init(generator: TestFailingObjectGeneratorWithConfiguratorModification) {
        self.generator = generator
    }
    
    public func generate<T: RepresentableByFields>(
        type: T.Type,
        configure: @escaping (TestFailingDynamicLookupConfigurator<T>) throws -> ())
        -> T
    {
        return generator.generate(
            type: type,
            configure: configure
        )
    }
}
