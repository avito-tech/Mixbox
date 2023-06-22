public class OrMatcher<T>: CompoundMatcher<T> {
    public init(
        _ matchers: [Matcher<T>],
        // Set to true to increase preformance and decrease quality of result.
        // See `CompoundMatcherMode`
        skipMatchingWhenMatchOrMismatchIsDetected: Bool = false
    ) {
        super.init(
            prefix: "Any of",
            matchers: matchers,
            exactMatch: { matchingResults in
                matchingResults.contains(where: { (matchingResult) -> Bool in
                    matchingResult.matched
                })
            },
            percentageOfMatching: { matchingResults in
                // [0.1, 0.9, 0.2] => 0.9
                matchingResults.reduce(Double(0)) { result, matchingResult in
                    max(result, matchingResult.percentageOfMatching)
                }
            },
            compoundMatcherMode: skipMatchingWhenMatchOrMismatchIsDetected ? .skipMatchingWhenMatchOrMismatchIsDetected(
                skippedMatchingResultsFactory: {
                    MatchingResult.match
                }
            ) : .alwaysUseAllMatchers
        )
    }
}
