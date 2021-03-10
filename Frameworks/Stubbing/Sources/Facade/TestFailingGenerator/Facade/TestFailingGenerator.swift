public protocol TestFailingGenerator:
    TestFailingAnyGenerator,
    TestFailingObjectGenerator,
    TestFailingArrayGenerator,
    TestFailingDictionaryGenerator,
    TestFailingOptionalGenerator
{
}
