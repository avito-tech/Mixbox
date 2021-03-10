import MixboxGenerators

public final class TestFailingArrayGeneratorImpl: TestFailingArrayGenerator {
    private let testFailingObjectGeneratorWithConfiguratorModification: TestFailingObjectGeneratorWithConfiguratorModification
    private let testFailingAnyGenerator: TestFailingAnyGenerator
    
    public init(
        testFailingObjectGeneratorWithConfiguratorModification: TestFailingObjectGeneratorWithConfiguratorModification,
        testFailingAnyGenerator: TestFailingAnyGenerator)
    {
        self.testFailingObjectGeneratorWithConfiguratorModification = testFailingObjectGeneratorWithConfiguratorModification
        self.testFailingAnyGenerator = testFailingAnyGenerator
    }
    
    public func array<T>(
        count: Int,
        type: T.Type = T.self)
        -> [T]
    {
        return (0..<count).map { _ in
            testFailingAnyGenerator.generate(type: type)
        }
    }
    
    public func array<T: RepresentableByFields>(
        count: Int,
        type: T.Type = T.self,
        configure: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<T>) throws -> ())
        -> [T]
    {
        return (0..<count).map { index in
            testFailingObjectGeneratorWithConfiguratorModification.generate(
                type: type,
                index: index,
                configure: configure
            )
        }
    }
}
