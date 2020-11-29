public final class RecordedCallArgumentsMatcherBuilder {
    private let index: Int
    private let matchers: [FunctionalMatcher<RecordedCallArgument>]
    
    public init(
        index: Int,
        matchers: [FunctionalMatcher<RecordedCallArgument>])
    {
        self.index = index
        self.matchers = matchers
    }
    
    public convenience init() {
        self.init(
            index: 0,
            matchers: []
        )
    }
    
    public func matchNext<Matcher: MixboxMocksRuntime.Matcher>(_ matcher: Matcher)
        -> RecordedCallArgumentsMatcherBuilder
    {
        return Self(
            index: index,
            matchers: matchers + [recordedCallArgumentMatcher(matcher: matcher)]
        )
    }
    
    public func matchNext<ClosureType>(_ matcher: NonEscapingClosureMatcher<ClosureType>)
        -> RecordedCallArgumentsMatcherBuilder
    {
        return Self(
            index: index,
            matchers: matchers + [nonEscapingClosureMatcher(closureType: ClosureType.self)]
        )
    }
    
    public func matcher() -> RecordedCallArgumentsMatcher {
        return RecordedCallArgumentsMatcher(
            matchingFunction: { [matchers] recordedCallArguments in
                recordedCallArguments.arguments.elementsEqual(matchers) { (recordedCallArgument, matcher) -> Bool in
                    matcher.valueIsMatching(recordedCallArgument)
                }
            }
        )
    }
    
    // MARK: - Private
    
    private func recordedCallArgumentMatcher<Matcher: MixboxMocksRuntime.Matcher>(
        matcher: Matcher)
        -> FunctionalMatcher<RecordedCallArgument>
    {
        return FunctionalMatcher { argument in
            if let value = argument.typedNestedValue(type: Matcher.MatchingType.self) {
                return matcher.valueIsMatching(value)
            } else {
                return false
            }
        }
    }
    
    private func nonEscapingClosureMatcher(
        closureType: Any.Type)
        -> FunctionalMatcher<RecordedCallArgument>
    {
        return FunctionalMatcher { argument in
            argument.asNonEscapingClosureType() == closureType
        }
    }
}
