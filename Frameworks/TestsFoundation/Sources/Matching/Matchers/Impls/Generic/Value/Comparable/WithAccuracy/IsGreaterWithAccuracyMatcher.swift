public final class IsGreaterWithAccuracyMatcher<T>: BaseComparableWithAccuracyMatcher<T> where T: Comparable, T: AdditiveArithmetic {
    public init(_ otherValue: T, accuracy: T) {
        super.init(
            otherValue: otherValue,
            accuracy: accuracy,
            comparisonOperatorInfo: .greaterThan
        )
    }
}
