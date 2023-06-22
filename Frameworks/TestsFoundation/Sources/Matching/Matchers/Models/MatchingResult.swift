public enum MatchingResult: Equatable {
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
    
    public static func == (lhs: MatchingResult, rhs: MatchingResult) -> Bool {
        switch (lhs, rhs) {
        case (.match, .match):
            return true
        case let (.mismatch(lhs), .mismatch(rhs)):
            return lhs.mismatchDescription == rhs.mismatchDescription
                && lhs.percentageOfMatching == rhs.percentageOfMatching
                && lhs.attachments == rhs.attachments
        case (.match, .mismatch), (.mismatch, .match):
            return false
        }
    }
}
