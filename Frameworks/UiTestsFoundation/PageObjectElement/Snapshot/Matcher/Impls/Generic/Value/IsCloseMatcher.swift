public typealias IsCloseMatcherCompatible = AbsoluteValueProvider
    & Subtractable
    & Divisible
    & DoubleValueProvider
    & Comparable

public final class IsCloseMatcher<T: IsCloseMatcherCompatible>: Matcher<T> {
    public init(expectedValue: T, delta: T) {
        super.init(
            description: {
                "равно \(expectedValue) +/- \(delta)"
            },
            matchingFunction: { actualValue in
                let actualDelta = actualValue.bySubtracting(expectedValue).absoluteValue()
                if actualDelta > delta {
                    return .partialMismatch(
                        percentageOfMatching: delta.byDividing(actualDelta).doubleValue(),
                        mismatchDescription: {
                            "актуальное значение: \(actualValue),"
                                + " ожидаемое значение: \(expectedValue),"
                                + " разница \(actualDelta) > \(delta)"
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
