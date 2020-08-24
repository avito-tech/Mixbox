import MixboxGenerators

public final class TestFailingOptionalGeneratorImpl: TestFailingOptionalGenerator {
    private let testFailingAnyGenerator: TestFailingAnyGenerator
    private let testFailingObjectGenerator: TestFailingObjectGenerator
    
    public init(
        testFailingAnyGenerator: TestFailingAnyGenerator,
        testFailingObjectGenerator: TestFailingObjectGenerator)
    {
        self.testFailingAnyGenerator = testFailingAnyGenerator
        self.testFailingObjectGenerator = testFailingObjectGenerator
    }
    
    public func some<T>(
        type: T.Type)
        -> T?
    {
        return testFailingAnyGenerator.generate(type: T.self)
    }
    
    public func some<T: RepresentableByFields>(
        type: T.Type,
        configure: @escaping (TestFailingDynamicLookupConfigurator<T>) throws -> ())
        -> T?
    {
        return testFailingObjectGenerator.generate(
            type: type,
            configure: configure
        )
    }
}
