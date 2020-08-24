import MixboxTestsFoundation
import MixboxGenerators

public final class TestFailingAnyGeneratorImpl: TestFailingAnyGenerator {
    private let anyGenerator: AnyGenerator

    public init(anyGenerator: AnyGenerator) {
        self.anyGenerator = anyGenerator
    }

    public func generate<T>(type: T.Type) -> T {
        return UnavoidableFailure.doOrFail {
            try anyGenerator.generate()
        }
    }
}
