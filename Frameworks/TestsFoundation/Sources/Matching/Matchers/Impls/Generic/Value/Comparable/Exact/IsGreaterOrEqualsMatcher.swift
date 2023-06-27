public final class IsGreaterOrEqualsMatcher<T: Comparable>: BaseComparableMatcher<T> {
    public init(_ otherValue: T) {
        super.init(
            otherValue: otherValue,
            comparisonOperatorInfo: .greaterThanOrEqualTo
        )
    }
}
