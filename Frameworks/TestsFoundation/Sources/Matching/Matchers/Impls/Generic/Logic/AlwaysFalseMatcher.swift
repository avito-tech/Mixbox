public class AlwaysFalseMatcher<T>: Matcher<T> {
    public init() {
        super.init(
            description: { "Всегда ложно" },
            matchingFunction: { _ in
                MatchingResult.exactMismatch(
                    mismatchDescription: { "Всегда ложно" },
                    attachments: { [] }
                )
            }
        )
    }
}
