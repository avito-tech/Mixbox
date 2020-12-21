public final class IsLessOrEqualsMatcher<T: Comparable>: Matcher<T> {
    public init(_ otherValue: T) {
        super.init(
            description: {
                "is less than or equal to \(otherValue)"
            },
            matchingFunction: { actualValue in
                if actualValue <= otherValue {
                    return .match
                } else {
                    return .exactMismatch(
                        mismatchDescription: {
                            """
                            value is not less than or equal to '\(otherValue)', \
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
