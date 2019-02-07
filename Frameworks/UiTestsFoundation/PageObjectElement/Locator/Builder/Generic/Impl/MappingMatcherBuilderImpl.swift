open class MappingMatcherBuilderImpl<TargetMatcherArgumentT, SourceMatcherArgumentT>: MappingMatcherBuilder {
    public typealias TargetMatcherArgument = TargetMatcherArgumentT
    public typealias SourceMatcherArgument = SourceMatcherArgumentT
    
    private let mapper: (Matcher<SourceMatcherArgument>) -> Matcher<TargetMatcherArgument>
    
    public init(_ mapper: @escaping (Matcher<SourceMatcherArgument>) -> Matcher<TargetMatcherArgument>) {
        self.mapper = mapper
    }
    
    public func matcher(_ matcher: Matcher<SourceMatcherArgument>) -> Matcher<TargetMatcherArgument> {
        return mapper(matcher)
    }
}
