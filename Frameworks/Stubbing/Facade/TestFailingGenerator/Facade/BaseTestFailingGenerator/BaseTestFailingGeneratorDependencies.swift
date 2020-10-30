public final class BaseTestFailingGeneratorDependencies {
    public let testFailingAnyGenerator: TestFailingAnyGenerator
    public let testFailingObjectGenerator: TestFailingObjectGenerator
    public let testFailingArrayGenerator: TestFailingArrayGenerator
    public let testFailingDictionaryGenerator: TestFailingDictionaryGenerator
    public let testFailingOptionalGenerator: TestFailingOptionalGenerator
    public let testFailingGeneratorObserver: TestFailingGeneratorObserver
    
    public init(
        testFailingAnyGenerator: TestFailingAnyGenerator,
        testFailingObjectGenerator: TestFailingObjectGenerator,
        testFailingArrayGenerator: TestFailingArrayGenerator,
        testFailingDictionaryGenerator: TestFailingDictionaryGenerator,
        testFailingOptionalGenerator: TestFailingOptionalGenerator,
        testFailingGeneratorObserver: TestFailingGeneratorObserver)
    {
        self.testFailingAnyGenerator = testFailingAnyGenerator
        self.testFailingObjectGenerator = testFailingObjectGenerator
        self.testFailingArrayGenerator = testFailingArrayGenerator
        self.testFailingDictionaryGenerator = testFailingDictionaryGenerator
        self.testFailingOptionalGenerator = testFailingOptionalGenerator
        self.testFailingGeneratorObserver = testFailingGeneratorObserver
    }
}
