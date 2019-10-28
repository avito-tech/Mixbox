import MixboxTestsFoundation

public enum MatchingResult {
    public static let exactMismatchPercentage: Double = 0
    public static let exactMatchPercentage: Double = 1
    
    case mismatch(MismatchResult)
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
        case .mismatch(let mismatchResult):
            return mismatchResult.percentageOfMatching
        }
    }
    
    public static func partialMismatch(
        percentageOfMatching: Double,
        mismatchDescription: @escaping () -> String,
        attachments: @escaping () -> [Attachment])
        -> MatchingResult
    {
        return .mismatch(
            LazyMismatchResult.partialMismatch(
                percentageOfMatching: percentageOfMatching,
                mismatchDescription: mismatchDescription,
                attachments: attachments
            )
        )
    }
    
    public static func exactMismatch(
        mismatchDescription: @escaping () -> String,
        attachments: @escaping () -> [Attachment])
        -> MatchingResult
    {
        return .mismatch(
            LazyMismatchResult.exactMismatch(
                mismatchDescription: mismatchDescription,
                attachments: attachments
            )
        )
    }
}
