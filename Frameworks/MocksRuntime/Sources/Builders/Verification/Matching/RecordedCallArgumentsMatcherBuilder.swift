import MixboxTestsFoundation

public final class RecordedCallArgumentsMatcherBuilder {
    private let index: Int
    private let matchers: [Matcher<RecordedCallArgument>]
    
    public init(
        index: Int,
        matchers: [Matcher<RecordedCallArgument>])
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
    
    public func matchNext<T>(_ matcher: Matcher<T>)
        -> RecordedCallArgumentsMatcherBuilder
    {
        let nextMatcher = MatcherToRecordedCallArgumentMatcher(
            matcher: matcher
        )
        
        return Self(
            index: index,
            matchers: matchers + [nextMatcher]
        )
    }
    
    public func matchNext<ClosureType>(_ matcher: NonEscapingClosureMatcher<ClosureType>)
        -> RecordedCallArgumentsMatcherBuilder
    {
        let nextMatcher = NonEscapingClosureTypeToRecordedCallArgumentMatcher(
            closureType: ClosureType.self
        )
        
        return Self(
            index: index,
            matchers: matchers + [nextMatcher]
        )
    }
    
    public func matcher() -> Matcher<RecordedCallArguments> {
        return RecordedCallArgumentsMatcher(matchers: matchers)
    }
}
