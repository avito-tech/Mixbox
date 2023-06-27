extension MappingMatcherBuilder where SourceMatcherArgument: Comparable, SourceMatcherArgument: AdditiveArithmetic {
    public func isGreaterThan(_ value: SourceMatcherArgument, accuracy: SourceMatcherArgument) -> Matcher<TargetMatcherArgument> {
        return matcher(IsGreaterWithAccuracyMatcher(value, accuracy: accuracy))
    }
    
    public func isLessThan(_ value: SourceMatcherArgument, accuracy: SourceMatcherArgument) -> Matcher<TargetMatcherArgument> {
        return matcher(IsLessWithAccuracyMatcher(value, accuracy: accuracy))
    }
    
    public func isGreaterThanOrEquals(_ value: SourceMatcherArgument, accuracy: SourceMatcherArgument) -> Matcher<TargetMatcherArgument> {
        return matcher(IsGreaterOrEqualsWithAccuracyMatcher(value, accuracy: accuracy))
    }
    
    public func isLessThanOrEquals(_ value: SourceMatcherArgument, accuracy: SourceMatcherArgument) -> Matcher<TargetMatcherArgument> {
        return matcher(IsLessOrEqualsWithAccuracyMatcher(value, accuracy: accuracy))
    }
}
