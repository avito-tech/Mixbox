open class BaseComparableMatcher<T: Comparable>: Matcher<T> {
    public init(
        otherValue: T,
        comparisonOperatorInfo: ComparisonOperatorInfo<T>
    ) {
        super.init(
            description: {
                "is \(comparisonOperatorInfo.description) \(otherValue)"
            },
            matchingFunction: { actualValue in
                if comparisonOperatorInfo.comparisonOperator(actualValue, otherValue) {
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
