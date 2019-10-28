public final class EqualsMatcher<T: Equatable>: Matcher<T> {
    public init(_ expectedValue: T) {
        super.init(
            description: {
                "равно \(expectedValue)"
            },
            matchingFunction: { actualValue in
                if actualValue == expectedValue {
                    return .match
                } else {
                    return .exactMismatch(
                        mismatchDescription: {
                            "не равно '\(expectedValue)', актуальное значение: '\(actualValue)')"
                        },
                        attachments: { [] }
                    )
                }
            }
        )
    }
}
