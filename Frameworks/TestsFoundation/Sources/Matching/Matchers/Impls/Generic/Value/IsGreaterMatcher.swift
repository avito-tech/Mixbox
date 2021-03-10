public final class IsGreaterMatcher<T: Comparable>: Matcher<T> {
    public init(_ otherValue: T) {
        super.init(
            description: {
                "is greater than \(otherValue)"
            },
            matchingFunction: { actualValue in
                if actualValue > otherValue {
                    return .match
                } else {
                    return .exactMismatch(
                        mismatchDescription: {
                            """
                            value is not greater than '\(otherValue)', \
                            actual value: '\(actualValue)'
                            """
                        },
                        attachments: { [] }
                    )
                }
            }
        )
    }
}
