public class NotMatcher<T>: Matcher<T> {
    public init(_ matcher: Matcher<T>) {
        super.init(
            description: {
                "Отрицание матчера " + matcher.description
            },
            matchingFunction: { value in
                if !matcher.matches(value: value).matched {
                    return .match
                } else {
                    return MatchingResult.exactMismatch(
                        mismatchDescription: { "Отрицание матчера зафейлилось: " + matcher.description }
                    )
                }
            }
        )
    }
}
