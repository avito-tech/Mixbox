public class AndMatcher<T>: CompoundMatcher<T> {
    public init(
        _ matchers: [Matcher<T>],
        // Set to true to increase preformance and decrease quality of result.
        // See `CompoundMatcherMode`
        skipMatchingWhenMatchOrMismatchIsDetected: Bool = false
    ) {
        super.init(
            prefix: "All of",
            matchers: matchers,
            exactMatch: { matchingResults in
                !matchingResults.isEmpty && matchingResults.allSatisfy({ matchingResult in
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
            },
            compoundMatcherMode: skipMatchingWhenMatchOrMismatchIsDetected ? .skipMatchingWhenMatchOrMismatchIsDetected(
                skippedMatchingResultsFactory: {
                    MatchingResult.mismatch(
                        LazyMismatchResult(
                            percentageOfMatching: 0,
                            mismatchDescriptionFactory: {
                                """
                                Skipped due to `skipMatchingWhenMatchOrMismatchIsDetected` == true and matching failure
                                """
                            },
                            attachmentsFactory: { [] }
                        )
                    )
                }
            ) : .alwaysUseAllMatchers
        )
    }
}

//public final class SequenceOf<Element, Iterator: IteratorProtocol>: Sequence where Iterator.Element == Element {
//    private let makeIteratorClosure: () -> Iterator
//
//    public init<Other: Sequence>(sequence: Other) where Other.Element == Element, Other.Iterator == Iterator {
//        self.makeIteratorClosure = sequence.makeIterator
//    }
//
//    public func makeIterator() -> Iterator {
//        return makeIteratorClosure()
//    }
//}
