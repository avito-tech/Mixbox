public final class MismatchResult {
    public let percentageOfMatching: Double
    public let mismatchDescription: () -> String
    
    public init(
        percentageOfMatching: Double,
        mismatchDescription: @escaping () -> String)
    {
        self.percentageOfMatching = percentageOfMatching
        self.mismatchDescription = mismatchDescription
    }
}
