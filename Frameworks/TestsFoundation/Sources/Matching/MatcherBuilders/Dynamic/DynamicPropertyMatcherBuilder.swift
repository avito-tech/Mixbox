@dynamicMemberLookup
public final class DynamicPropertyMatcherBuilder<TargetMatcherArgument, PropertyType>:
    MappingMatcherBuilderImpl<TargetMatcherArgument, PropertyType>
    where
    TargetMatcherArgument: AllNamedKeyPathsProvider
{
    private let name: String
    private let getter: (TargetMatcherArgument) -> PropertyType
    
    public init(
        name: String,
        getter: @escaping (TargetMatcherArgument) -> PropertyType)
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
        keyPath: KeyPath<TargetMatcherArgument, PropertyType>)
    {
        let name = TargetMatcherArgument.allNamedKeyPaths.name(keyPath: keyPath)
            ?? Self.fallbackPropertyName()
        
        self.init(
            name: name,
            getter: { $0[keyPath: keyPath] }
        )
    }
    
    private static func fallbackPropertyName() -> String {
        return """
        (property with unknown name, please check that `\(TargetMatcherArgument.self)` \
        conforms to `AllNamedKeyPathsProvider` properly)
        """
    }
}

extension DynamicPropertyMatcherBuilder where PropertyType: AllNamedKeyPathsProvider {
    public subscript<FieldType>(
        dynamicMember keyPath: KeyPath<PropertyType, FieldType>)
    -> DynamicPropertyMatcherBuilder<TargetMatcherArgument, FieldType>
    {
        get {
            let nestedPropertyName = PropertyType.allNamedKeyPaths.name(keyPath: keyPath)
                ?? Self.fallbackPropertyName()
            
            return DynamicPropertyMatcherBuilder<TargetMatcherArgument, FieldType>(
                name: "\(self.name).\(nestedPropertyName)",
                getter: {
                    let thisPropertyValue = self.getter($0)
                    return thisPropertyValue[keyPath: keyPath]
                }
            )
        }
    }
}
