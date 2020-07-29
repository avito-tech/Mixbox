// TODO: Ability to not iterate over every element.
// This will increase performance, but make log
public class AndMatcher<T>: CompoundMatcher<T> {
    public init(_ matchers: [Matcher<T>]) {
        super.init(
            prefix: "Всё из",
            matchers: matchers,
            exactMatch: { (matchingResults: [MatchingResult]) -> Bool in
                !matchingResults.isEmpty && matchingResults.allSatisfy({ (matchingResult) -> Bool in
                    matchingResult.matched
                })
            },
            percentageOfMatching: { matchingResults in
                if matchingResults.isEmpty {
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
