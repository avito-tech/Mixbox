extension MappingMatcherBuilder where SourceMatcherArgument: Equatable {
    public func equals(_ value: SourceMatcherArgument) -> Matcher<TargetMatcherArgument> {
        return matcher(EqualsMatcher(value))
    }
    
    // MARK: - Operators
    
    public static func ==(left: Self, right: SourceMatcherArgument) -> Matcher<TargetMatcherArgument> {
        return left.equals(right)
    }
    
    public static func ==(left: SourceMatcherArgument, right: Self) -> Matcher<TargetMatcherArgument> {
        return right.equals(left)
    }
    
    public static func !=(left: Self, right: SourceMatcherArgument) -> Matcher<TargetMatcherArgument> {
        return !left.equals(right)
    }
    
    public static func !=(left: SourceMatcherArgument, right: Self) -> Matcher<TargetMatcherArgument> {
        return !right.equals(left)
    }
}
