public typealias IsCloseMatcherCompatible = AbsoluteValueProvider
    & Subtractable
    & Divisible
    & DoubleValueProvider
    & Comparable

public final class IsCloseMatcher<T: IsCloseMatcherCompatible>: Matcher<T> {
    public init(expectedValue: T, delta: T) {
        super.init(
            description: {
                "equals to \(expectedValue) +/- \(delta)"
            },
            matchingFunction: { actualValue in
                let actualDelta = actualValue.bySubtracting(expectedValue).absoluteValue()
                if actualDelta > delta {
                    return .partialMismatch(
                        percentageOfMatching: delta.byDividing(actualDelta).doubleValue(),
                        mismatchDescription: {
                            "actual value: \(actualValue),"
                                + " expected value: \(expectedValue),"
                                + " difference: \(actualDelta) > \(delta)"
                        },
                        attachments: { [] }
                    )
                } else {
                    return .match
                }
            }
        )
    }
}
