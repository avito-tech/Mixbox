extension MappingMatcherBuilder where SourceMatcherArgument: Comparable {
    public func isGreaterThan(_ value: SourceMatcherArgument) -> Matcher<TargetMatcherArgument> {
        return matcher(IsGreaterMatcher(value))
    }
    
    public func isLessThan(_ value: SourceMatcherArgument) -> Matcher<TargetMatcherArgument> {
        return matcher(IsLessMatcher(value))
    }
    
    public func isGreaterThanOrEquals(_ value: SourceMatcherArgument) -> Matcher<TargetMatcherArgument> {
        return matcher(IsGreaterOrEqualsMatcher(value))
    }
    
    public func isLessThanOrEquals(_ value: SourceMatcherArgument) -> Matcher<TargetMatcherArgument> {
        return matcher(IsLessOrEqualsMatcher(value))
    }
    
    // MARK: - Operators
    
    public static func >(left: Self, right: SourceMatcherArgument) -> Matcher<TargetMatcherArgument> {
        return left.isGreaterThan(right)
    }
    
    public static func >(left: SourceMatcherArgument, right: Self) -> Matcher<TargetMatcherArgument> {
        return right < left
    }
    
    public static func <(left: Self, right: SourceMatcherArgument) -> Matcher<TargetMatcherArgument> {
        return left.isLessThan(right)
    }
    
    public static func <(left: SourceMatcherArgument, right: Self) -> Matcher<TargetMatcherArgument> {
        return right > left
    }
    
    public static func >=(left: Self, right: SourceMatcherArgument) -> Matcher<TargetMatcherArgument> {
        return left.isGreaterThanOrEquals(right)
    }
    
    public static func >=(left: SourceMatcherArgument, right: Self) -> Matcher<TargetMatcherArgument> {
        return right <= left
    }
    
    public static func <=(left: Self, right: SourceMatcherArgument) -> Matcher<TargetMatcherArgument> {
        return left.isLessThanOrEquals(right)
    }
    
    public static func <=(left: SourceMatcherArgument, right: Self) -> Matcher<TargetMatcherArgument> {
        return right >= left
    }
}
