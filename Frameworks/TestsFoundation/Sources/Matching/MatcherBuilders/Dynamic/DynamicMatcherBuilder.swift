@dynamicMemberLookup
public final class DynamicMatcherBuilder<T: AllNamedKeyPathsProvider>: MappingMatcherBuilder {
    public typealias TargetMatcherArgument = T
    public typealias SourceMatcherArgument = T
    
    public init() {
    }
    
    public subscript<FieldType>(
        dynamicMember keyPath: KeyPath<T, FieldType>)
        -> DynamicPropertyMatcherBuilder<T, FieldType>
    {
        return DynamicPropertyMatcherBuilder(
            keyPath: keyPath
        )
    }
    
    // No mapping here. However, there are a lot of extensions written
    // for `MappingMatcherBuilder` (more general case of matcher builders),
    // so we inheit from `MappingMatcherBuilder`.
    public func matcher(_ matcher: Matcher<SourceMatcherArgument>) -> Matcher<TargetMatcherArgument> {
        return matcher
    }
}
