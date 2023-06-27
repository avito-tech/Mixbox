public final class IsLessMatcher<T: Comparable>: BaseComparableMatcher<T> {
    public init(_ otherValue: T) {
        super.init(
            otherValue: otherValue,
            comparisonOperatorInfo: .lessThan
        )
    }
}
