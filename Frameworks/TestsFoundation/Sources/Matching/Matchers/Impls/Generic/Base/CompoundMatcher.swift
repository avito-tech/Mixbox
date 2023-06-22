import MixboxFoundation

public enum CompoundMatcherMode {
    case alwaysUseAllMatchers
    
    // If `exactMatch` does not execute `match` for every matcher, do not continue to execute them.
    // `AndMatcher` can exit early when finds first mismatch, `OrMatcher` can exit early when finds first match.
    // This may greatly increase performance, for example, in cases when matchers are slow (example: comparing images).
    // However, the quality of result may get worse. `percentageOfMatching` will not take into account all results,
    // since some results are not received. Also, `mismatchDescription` will not contain all mismatches.
    case skipMatchingWhenMatchOrMismatchIsDetected(
        skippedMatchingResultsFactory: () -> MatchingResult
    )
}

public class CompoundMatcher<T>: Matcher<T> {
    public init(
        prefix: String,
        matchers: [Matcher<T>],
        exactMatch: @escaping (CachingLazyMappingSequence<Matcher<T>, MatchingResult>) -> Bool,
        percentageOfMatching: @escaping ([MatchingResult]) -> Double,
        compoundMatcherMode: CompoundMatcherMode
    ) {
        super.init(
            description: CompoundMatcher.joinedDescriptions(
                prefix: prefix,
                matchers: matchers
            ),
            matchingFunction: { value in
                let lazyMatchingResults = CachingLazyMappingSequence(
                    sourceElements: matchers,
                    transform: { $0.match(value: value) }
                )
                
                if exactMatch(lazyMatchingResults) {
                    return MatchingResult.match
                } else {
                    let matchingResults: [MatchingResult]
                    
                    switch compoundMatcherMode {
                    case .alwaysUseAllMatchers:
                        matchingResults = lazyMatchingResults.allElements
                    case .skipMatchingWhenMatchOrMismatchIsDetected(let skippedMatchingResultsFactory):
                        matchingResults = lazyMatchingResults.mappedElements + Array(
                            repeating: skippedMatchingResultsFactory(),
                            count: lazyMatchingResults.sourceElements.count - lazyMatchingResults.mappedElements.count
                        )
                    }
                    
                    return MatchingResult.partialMismatch(
                        percentageOfMatching: percentageOfMatching(matchingResults),
                        mismatchDescription: CompoundMatcher.joinedFails(
                            prefix: prefix,
                            matchers: matchers,
                            results: matchingResults
                        ),
                        attachments: CompoundMatcher.joinedAttachments(
                            matchers: matchers,
                            results: matchingResults
                        )
                    )
                }
            }
        )
    }
    
    private static func joinedDescriptions(
        prefix: String,
        matchers: [Matcher<T>])
        -> () -> String
    {
        return {
            prefix + " " + CompoundMatcher.joined(strings: matchers.map { $0.description })
        }
    }
    
    private static func joinedFails(
        prefix: String,
        matchers: [Matcher<T>],
        results: [MatchingResult])
        -> () -> String
    {
        return {
            prefix + " " + CompoundMatcher.joined(
                strings: zip(matchers, results).map { matcher, result in
                    CompoundMatcher.fail(matcher: matcher, result: result)
                }
            )
        }
    }
    
    private static func joinedAttachments(
        matchers: [Matcher<T>],
        results: [MatchingResult])
        -> () -> [Attachment]
    {
        return {
            results.enumerated().compactMap { index, result in
                switch result {
                case .mismatch(let mismatchResult):
                    let attachments = mismatchResult.attachments
                    
                    if attachments.isEmpty {
                        return nil
                    } else {
                        return Attachment(
                            name: "Attachments for mismatched element #\(index)",
                            content: .attachments(attachments)
                        )
                    }
                case .match:
                    return nil
                }
            }
        }
    }
    
    private static func joined(strings: [String]) -> String {
        return strings.joined(separator: "\n").mb_wrapAndIndent(
            prefix: "[",
            postfix: "]"
        )
    }
    
    private static func matchDescription(matcherDescription: @escaping @autoclosure () -> String) -> String {
        return "(v) " + matcherDescription()
    }
    
    private static func mismatchDescription(matcherDescription: @escaping @autoclosure () -> String) -> String {
        return "(x) " + matcherDescription()
    }
    
    private static func fail(matcher: Matcher<T>, result: MatchingResult) -> String {
        switch result {
        case .match:
            return matchDescription(matcherDescription: matcher.description)
        case .mismatch(let mismatchResult):
            return mismatchDescription(matcherDescription: mismatchResult.mismatchDescription)
        }
    }
}
