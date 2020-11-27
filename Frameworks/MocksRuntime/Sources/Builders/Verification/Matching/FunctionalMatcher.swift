import Foundation

open class FunctionalMatcher<MatchingType>: Matcher {
    public typealias MatchingType = MatchingType
    
    private let matchingFunction: (MatchingType) -> Bool
    
    public init(matchingFunction: @escaping (MatchingType) -> Bool) {
        self.matchingFunction = matchingFunction
    }
    
    public init<U: Matcher>(matcher: U) where U.MatchingType == MatchingType {
        self.matchingFunction = matcher.valueIsMatching
    }
    
    public func valueIsMatching(_ value: MatchingType) -> Bool {
        return matchingFunction(value)
    }
}

extension FunctionalMatcher {
    public func byErasingType() -> FunctionalMatcher<Any> {
        return FunctionalMatcher<Any>(
            matchingFunction: { arguments in
                if let argumentsAsT = arguments as? MatchingType {
                    return self.valueIsMatching(argumentsAsT)
                } else {
                    return false
                }
            }
        )
    }
}

public func any<MatchingType>() -> FunctionalMatcher<MatchingType> {
    return FunctionalMatcher<MatchingType> { _ in true }
}

public func none<MatchingType>() -> FunctionalMatcher<MatchingType> {
    return FunctionalMatcher<MatchingType> { _ in false }
}

public func equals<MatchingType>(
    _ value: MatchingType)
    -> FunctionalMatcher<MatchingType>
    where
    MatchingType: Equatable
{
    return FunctionalMatcher<MatchingType> { other in value == other }
}

public func isSame<MatchingType>(
    _ value: MatchingType)
    -> FunctionalMatcher<MatchingType>
    where
    MatchingType: AnyObject
{
    return FunctionalMatcher<MatchingType> { other in value === other }
}

public func isSame(
    _ value: AnyObject.Type)
    -> FunctionalMatcher<AnyObject.Type>
{
    return FunctionalMatcher<AnyObject.Type> { other in value === other }
}

public func isSame(
    _ value: NSObject.Type)
    -> FunctionalMatcher<NSObject.Type>
{
    return FunctionalMatcher<NSObject.Type> { other in value === other }
}

public func atLeast<MatchingType>(
    _ atLeast: MatchingType)
    -> FunctionalMatcher<MatchingType>
    where
    MatchingType: Comparable
{
    return FunctionalMatcher<MatchingType> { given in given >= atLeast }
}

public func atMost<MatchingType>(
    _ atLeast: MatchingType)
    -> FunctionalMatcher<MatchingType>
    where
    MatchingType: Comparable
{
    return FunctionalMatcher<MatchingType> { given in given <= atLeast }
}
