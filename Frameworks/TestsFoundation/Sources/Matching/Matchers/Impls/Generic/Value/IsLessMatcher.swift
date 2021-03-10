public final class IsLessMatcher<T: Comparable>: Matcher<T> {
    public init(_ otherValue: T) {
        super.init(
            description: {
                "is less than \(otherValue)"
            },
            matchingFunction: { actualValue in
                if actualValue < otherValue {
                    return .match
                } else {
                    return .exactMismatch(
                        mismatchDescription: {
                            """
                            value is not less than '\(otherValue)', \
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
