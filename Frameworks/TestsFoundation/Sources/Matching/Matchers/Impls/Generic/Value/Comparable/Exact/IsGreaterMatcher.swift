public final class IsGreaterMatcher<T: Comparable>: BaseComparableMatcher<T> {
    public init(_ otherValue: T) {
        super.init(
            otherValue: otherValue,
            comparisonOperatorInfo: .greaterThan
        )
    }
}
