import Foundation
import MixboxTestsFoundation

extension Matcher {
    public func byErasingType() -> Matcher<Any> {
        return Matcher<Any>(
            description: {
                "\(self.description) (converting result to \(MatchedType.self))"
            },
            matchingFunction: { value in
                if let valueAsT = value as? MatchedType {
                    return self.match(value: valueAsT)
                } else {
                    return .exactMismatch(
                        mismatchDescription: {
                            """
                            Expected value to be of type '\(MatchedType.self)', \
                            actual type: \(type(of: value)), \
                            value: \(value)
                            """
                        },
                        attachments: { [] }
                    )
                }
            }
        )
    }
}

public func any<MatchedType>(
    type: MatchedType.Type = MatchedType.self)
    -> Matcher<MatchedType>
{
    return AlwaysTrueMatcher()
}

public func none<MatchedType>(
    type: MatchedType.Type = MatchedType.self)
    -> Matcher<MatchedType>
{
    return AlwaysFalseMatcher()
}

public func matches<MatchedType>(
    type: MatchedType.Type = MatchedType.self,
    _ matchingFunction: @escaping (MatchedType) -> Bool)
    -> Matcher<MatchedType>
{
    return Matcher<MatchedType>(
        description: {
            "value is matched by custom function (without description)"
        },
        matchingFunction: {
            if matchingFunction($0) {
                return .match
            } else {
                return .exactMismatch(
                    mismatchDescription: {
                        "matching with custom function failed (without description)"
                    },
                    attachments: { [] }
                )
            }
        }
    )
}

public func equals<MatchedType>(
    _ value: MatchedType)
    -> Matcher<MatchedType>
    where
    MatchedType: Equatable
{
    return EqualsMatcher(value)
}

public func isSame<MatchedType>(
    _ value: MatchedType)
    -> Matcher<MatchedType>
    where
    MatchedType: AnyObject
{
    return IsSameInstanceMatcher(value)
}

public func isSame(
    _ value: AnyObject.Type)
    -> Matcher<AnyObject.Type>
{
    return IsSameInstanceMatcher(value)
}

public func isSame(
    _ value: NSObject.Type)
    -> Matcher<NSObject.Type>
{
    return IsSameInstanceMatcher(value)
}

public func atLeast<MatchingType>(
    _ minimumValue: MatchingType)
    -> Matcher<MatchingType>
    where
    MatchingType: Comparable
{
    return IsGreaterOrEqualsMatcher(minimumValue)
}

public func atMost<MatchingType>(
    _ maximumValue: MatchingType)
    -> Matcher<MatchingType>
    where
    MatchingType: Comparable
{
    return IsLessOrEqualsMatcher(maximumValue)
}
