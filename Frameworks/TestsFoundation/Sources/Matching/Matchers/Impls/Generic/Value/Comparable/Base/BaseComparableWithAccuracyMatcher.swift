open class BaseComparableWithAccuracyMatcher<T>: Matcher<T> where T: Comparable, T: AdditiveArithmetic {
    public init(
        otherValue: T,
        accuracy: T,
        comparisonOperatorInfo: ComparisonOperatorInfo<T>
    ) {
        let zero = accuracy - accuracy
        let accuracyIsLessThanZero = accuracy < zero
        
        super.init(
            description: {
                "is \(comparisonOperatorInfo.description) \(otherValue) (with accuracy ±\(accuracy))"
            },
            matchingFunction: { actualValue in
                if accuracyIsLessThanZero {
                    return .exactMismatch(
                        mismatchDescription: {
                            """
                            matcher is invalid, accuracy is less than zero: \(accuracy)
                            """
                        },
                        attachments: { [] }
                    )
                } else {
                    let modification: (T, T) -> T = comparisonOperatorInfo.isGreater ? (+) : (-)
                    let modifiedValue = modification(actualValue, accuracy)
                    
                    if comparisonOperatorInfo.comparisonOperator(modifiedValue, otherValue) {
                        return .match
                    } else {
                        return .exactMismatch(
                            mismatchDescription: {
                                """
                                value (with accuracy ±\(accuracy)) is not \(comparisonOperatorInfo.description) '\(otherValue)', \
                                actual value: '\(actualValue)'
                                """
                            },
                            attachments: { [] }
                        )
                    }
                }
            }
        )
    }
}
