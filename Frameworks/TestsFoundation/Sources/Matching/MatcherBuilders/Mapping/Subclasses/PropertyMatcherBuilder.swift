open class PropertyMatcherBuilder<TargetMatcherArgumentT, SourceMatcherArgumentT>:
    MappingMatcherBuilderImpl<TargetMatcherArgumentT, SourceMatcherArgumentT>
{
    private let name: String
    private let getter: (TargetMatcherArgument) -> SourceMatcherArgument
    
    public init(
        _ name: String,
        _ getter: @escaping (TargetMatcherArgument) -> SourceMatcherArgument)
    {
        self.name = name
        self.getter = getter
        
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
    
    public func nested<Nested, NestedBuilder>(
        _ name: String,
        _ getter: @escaping (SourceMatcherArgument) -> Nested,
        _ makeNestedBuilder: @escaping (String, @escaping (TargetMatcherArgumentT) -> Nested) -> NestedBuilder)
        -> NestedBuilder
    {
        let nestedPropertyName = name
        let nestedPropertyGetter = getter
        
        return makeNestedBuilder(
            "\(self.name).\(nestedPropertyName)",
            {
                let thisPropertyValue = self.getter($0)
                return nestedPropertyGetter(thisPropertyValue)
            }
        )
    }
    
    public func nested<Nested>(
        _ name: String,
        _ getter: @escaping (SourceMatcherArgument) -> Nested)
        -> PropertyMatcherBuilder<TargetMatcherArgumentT, Nested>
    {
        return nested(name, getter) {
            PropertyMatcherBuilder<TargetMatcherArgumentT, Nested>(
                $0, $1
            )
        }
    }
    
    public func nested<Nested>(
        _ name: String,
        _ keyPath: KeyPath<SourceMatcherArgument, Nested>)
        -> PropertyMatcherBuilder<TargetMatcherArgumentT, Nested>
    {
        return nested(name, { $0[keyPath: keyPath] })
    }
}
