public class AlwaysFalseMatcher<T>: Matcher<T> {
    public init() {
        super.init(
            description: { "Always false" },
            matchingFunction: { _ in
                MatchingResult.exactMismatch(
                    mismatchDescription: { "Always false" },
                    attachments: { [] }
                )
            }
        )
    }
}
