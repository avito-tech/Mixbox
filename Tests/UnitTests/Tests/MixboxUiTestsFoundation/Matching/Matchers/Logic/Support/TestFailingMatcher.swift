import MixboxTestsFoundation

// Matcher that fails tests. Can be used to check that it is never used.
public final class TestFailingMatcher: Matcher<Int> {
    public init() {
        super.init(
            description: { "This matcher should never be called" },
            matchingFunction: { _ in
                UnavoidableFailure.fail("Matcher was used, which is unexpected in this test")
            }
        )
    }
}
