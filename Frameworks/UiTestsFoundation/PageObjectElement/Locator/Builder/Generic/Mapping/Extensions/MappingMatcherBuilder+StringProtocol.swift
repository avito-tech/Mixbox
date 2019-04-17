// TODO: lowercased().contains(xxx)
extension MappingMatcherBuilder where SourceMatcherArgument: StringProtocol {
    public func matches<U: StringProtocol>(regularExpression: U) -> Matcher<TargetMatcherArgument> {
        return matcher(RegularExpressionMatcher(regularExpression: regularExpression))
    }
    
    public func contains<U: StringProtocol>(_ string: U) -> Matcher<TargetMatcherArgument> {
        return matcher(ContainsMatcher(string: string))
    }
    
    public func startsWith<U: StringProtocol>(_ string: U) -> Matcher<TargetMatcherArgument> {
        return matcher(StartsWithMatcher(string: string))
    }
    
    public var isEmpty: Matcher<TargetMatcherArgument> {
        return matcher(EqualsMatcher(""))
    }
    
    public var isNotEmpty: Matcher<TargetMatcherArgument> {
        return !isEmpty
    }
}
