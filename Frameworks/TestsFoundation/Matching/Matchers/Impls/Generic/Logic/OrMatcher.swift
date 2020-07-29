public class OrMatcher<T>: CompoundMatcher<T> {
    public init(_ matchers: [Matcher<T>]) {
        super.init(
            prefix: "Любое из",
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
            }
        )
    }
}
