public final class BaseTestFailingGeneratorDependencies {
    public let testFailingAnyGenerator: TestFailingAnyGenerator
    public let testFailingObjectGenerator: TestFailingObjectGenerator
    public let testFailingArrayGenerator: TestFailingArrayGenerator
    public let testFailingDictionaryGenerator: TestFailingDictionaryGenerator
    public let testFailingOptionalGenerator: TestFailingOptionalGenerator
    
    public init(
        testFailingAnyGenerator: TestFailingAnyGenerator,
        testFailingObjectGenerator: TestFailingObjectGenerator,
        testFailingArrayGenerator: TestFailingArrayGenerator,
        testFailingDictionaryGenerator: TestFailingDictionaryGenerator,
        testFailingOptionalGenerator: TestFailingOptionalGenerator)
    {
        self.testFailingAnyGenerator = testFailingAnyGenerator
        self.testFailingObjectGenerator = testFailingObjectGenerator
        self.testFailingArrayGenerator = testFailingArrayGenerator
        self.testFailingDictionaryGenerator = testFailingDictionaryGenerator
        self.testFailingOptionalGenerator = testFailingOptionalGenerator
    }
}
