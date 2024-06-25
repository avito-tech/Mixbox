public class NotMatcher<T>: Matcher<T> {
    public init(_ matcher: Matcher<T>) {
        super.init(
            description: {
                "not \(matcher.wrappedDescription)"
            },
            matchingFunction: { value in
                switch matcher.match(value: value) {
                case .match:
                    return MatchingResult.exactMismatch(
                        mismatchDescription: { "NotMatcher failed, nested matcher: " + matcher.description },
                        attachments: { [] }
                    )
                case .mismatch:
                    return .match
                }
            }
        )
    }
}
