import MixboxFoundation

// Example:
//
// let c = CustomValuesMatcherBuilder()
// c["key"] == "value" // returns matcher
public final class CustomValuesMatcherBuilder {
    public subscript<Casted: Codable>(_ key: String) -> CustomValueMatcherBuilder<Casted> {
        return CustomValueMatcherBuilder<Casted>(key: key)
    }
    
    public subscript<Casted: Codable>(_ key: String, _ type: Casted.Type) -> CustomValueMatcherBuilder<Casted> {
        return CustomValueMatcherBuilder<Casted>(key: key)
    }
}

// TODO: Add builder for matching existance of value by key?
public final class CustomValueMatcherBuilder<CustomValueType: Codable>: MappingMatcherBuilderImpl<ElementSnapshot, CustomValueType> {
    public init(key: String) {
        super.init { matcher in
            CustomValueMatcher<CustomValueType>(key: key, matcher: matcher)
        }
    }
}

public final class CustomValueMatcher<ValueType: Codable>: Matcher<ElementSnapshot> {
    public init(key: String, matcher: Matcher<ValueType>) {
        super.init(
            description: {
                "customValue['\(key)'] \(matcher.description)"
            },
            matchingFunction: { snapshot in
                do {
                    let value: ValueType = try snapshot.customValue(key: key)
                    
                    return matcher.match(value: value)
                } catch {
                    return .exactMismatch(
                        mismatchDescription: { "\(error)" },
                        attachments: { [] }
                    ) 
                }
            }
        )
    }
}
