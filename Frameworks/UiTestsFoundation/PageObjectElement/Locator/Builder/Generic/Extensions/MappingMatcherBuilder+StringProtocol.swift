extension MappingMatcherBuilder where SourceMatcherArgument: StringProtocol {
    func matches<U: StringProtocol>(regularExpression: U) -> Matcher<TargetMatcherArgument> {
        return matcher(RegularExpressionMatcher(regularExpression: regularExpression))
    }
    
    func contains<U: StringProtocol>(_ string: U) -> Matcher<TargetMatcherArgument> {
        return matcher(ContainsMatcher(string: string))
    }
}
