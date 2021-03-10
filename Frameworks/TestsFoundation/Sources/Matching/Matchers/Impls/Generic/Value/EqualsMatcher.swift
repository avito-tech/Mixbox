public final class EqualsMatcher<T: Equatable>: Matcher<T> {
    public init(_ expectedValue: T) {
        super.init(
            description: {
                "equals to \(expectedValue)"
            },
            matchingFunction: { actualValue in
                if actualValue == expectedValue {
                    return .match
                } else {
                    return .exactMismatch(
                        mismatchDescription: {
                            """
                            value is not equal to '\(expectedValue)', \
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
