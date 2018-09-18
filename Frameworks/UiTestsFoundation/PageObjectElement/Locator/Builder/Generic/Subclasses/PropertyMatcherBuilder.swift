public class PropertyMatcherBuilder<TargetMatcherArgumentT, SourceMatcherArgumentT>:
    MappingMatcherBuilderImpl<TargetMatcherArgumentT, SourceMatcherArgumentT>
{
    public init(
        _ name: String,
        _ getter: @escaping (TargetMatcherArgument) -> SourceMatcherArgument)
    {
        super.init {
            HasPropertyMatcher(
                property: getter,
                name: name,
                matcher: $0
            )
        }
    }
    
    public convenience init(
        _ name: String,
        _ keyPath: KeyPath<TargetMatcherArgument, SourceMatcherArgument>)
    {
        self.init(name, { $0[keyPath: keyPath] })
    }
}
