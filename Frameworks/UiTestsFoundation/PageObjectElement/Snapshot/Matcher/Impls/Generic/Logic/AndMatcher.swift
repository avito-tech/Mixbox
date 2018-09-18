public class AndMatcher<T>: CompoundMatcher<T> {
    public init(_ matchers: [Matcher<T>]) {
        super.init(
            prefix: "Всё из",
            matchers: matchers,
            exactMatch: { (matchingResults: [MatchingResult]) -> Bool in
                !matchingResults.isEmpty && matchingResults.reduce(true) { result, matchingResult in
                    result && matchingResult.matched
                }
            },
            percentageOfMatching: { matchingResults in
                if matchingResults.count == 0 {
                    return 0
                } else {
                    let sum = matchingResults.reduce(Double(0)) { result, matchingResult in
                        result + matchingResult.percentageOfMatching
                    }
                    return sum / Double(matchingResults.count)
                }
            }
        )
    }
}
