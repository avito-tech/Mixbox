import MixboxTestsFoundation

public final class TestFailingGeneratorImpl: TestFailingGenerator {
    private let anyGenerator: AnyGenerator

    public init(anyGenerator: AnyGenerator) {
        self.anyGenerator = anyGenerator
    }

    public func generate<T>() -> T {
        return UnavoidableFailure.doOrFail {
            try anyGenerator.generate()
        }
    }
}
