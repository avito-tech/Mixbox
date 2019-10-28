public class NotMatcher<T>: Matcher<T> {
    public init(_ matcher: Matcher<T>) {
        super.init(
            description: {
                "Отрицание матчера " + matcher.description
            },
            matchingFunction: { value in
                switch matcher.matches(value: value) {
                case .match:
                    return MatchingResult.exactMismatch(
                        mismatchDescription: { "Отрицание матчера зафейлилось: " + matcher.description },
                        attachments:  { [] }
                    )
                case .mismatch:
                    return .match
                }
            }
        )
    }
}
