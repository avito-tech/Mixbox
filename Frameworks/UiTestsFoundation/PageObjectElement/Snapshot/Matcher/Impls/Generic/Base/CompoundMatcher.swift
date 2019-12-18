import MixboxTestsFoundation

public class CompoundMatcher<T>: Matcher<T> {
    public init(
        prefix: String,
        matchers: [Matcher<T>],
        exactMatch: @escaping ([MatchingResult]) -> Bool,
        percentageOfMatching: @escaping ([MatchingResult]) -> Double)
    {
        super.init(
            description: CompoundMatcher.joinedDescriptions(
                prefix: prefix,
                matchers: matchers
            ),
            matchingFunction: { value in
                let matchingResults = matchers.map { $0.match(value: value) }
                
                if exactMatch(matchingResults) {
                    return MatchingResult.match
                } else {
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
