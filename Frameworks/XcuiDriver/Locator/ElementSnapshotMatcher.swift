// Matches existing view from accessibility hierarchy.
// Difference from XcuiElementMatcher: ElementSnapshot always exists, XCUIElement is not an element, but a query.
// TODO: Not public, protocol

public final class ElementSnapshotMatcher {
    public let description: () -> String
    private let matchingFunction: (ElementSnapshot) -> MatchingResult
    
    public init(
        description: @escaping () -> String,
        matchingFunction: @escaping (ElementSnapshot) -> MatchingResult)
    {
        self.description = description
        self.matchingFunction = matchingFunction
    }
    
    public func matches(snapshot: ElementSnapshot) -> MatchingResult {
        return matchingFunction(snapshot)
    }
}

public enum MatchingResult {
    public static let exactMismatchPercentage: Double = 0
    public static let exactMatchPercentage: Double = 1
    
    case mismatch(percentageOfMatching: Double, mismatchDescription: () -> String)
    case match
    
    public var matched: Bool {
        switch self {
        case .match:
            return true
        case .mismatch:
            return false
        }
    }
    
    public var percentageOfMatching: Double {
        switch self {
        case .match:
            return MatchingResult.exactMatchPercentage
        case .mismatch(let percentageOfMatching, _):
            return percentageOfMatching
        }
    }
    
    public static func partialMismatch(
        percentageOfMatching: Double,
        mismatchDescription: @escaping () -> String)
        -> MatchingResult
    {
        return .mismatch(percentageOfMatching: percentageOfMatching, mismatchDescription: mismatchDescription)
    }
    
    public static func exactMismatch(
        mismatchDescription: @escaping () -> String)
        -> MatchingResult
    {
        return .mismatch(percentageOfMatching: exactMismatchPercentage, mismatchDescription: mismatchDescription)
    }
}
