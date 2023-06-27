public final class IsLessOrEqualsMatcher<T: Comparable>: BaseComparableMatcher<T> {
    public init(_ otherValue: T) {
        super.init(
            otherValue: otherValue,
            comparisonOperatorInfo: .lessThanOrEqualTo
        )
    }
}
