import MixboxFoundation
import MixboxTestsFoundation

public final class IsSubviewMatcher: Matcher<ElementSnapshot> {
    public init(_ parentMatcher: Matcher<ElementSnapshot>) {
        super.init(
            description: {
                parentMatcher.description.mb_wrapAndIndent(
                    prefix: "is subview of {",
                    postfix: "}"
                )
            },
            matchingFunction: { snapshot -> MatchingResult in
                var parentPointer = snapshot.parent
                var bestPercentageOfMatching: Double = -Double.greatestFiniteMagnitude
                var bestMismatchResult: MismatchResult?
                
                if parentPointer == nil {
                    return .exactMismatch(
                        mismatchDescription: { "Is not subview (doesn't have superview)" },
                        attachments: { [] }
                    )
                }
                
                while let parent = parentPointer {
                    switch parentMatcher.match(value: parent) {
                    case .match:
                        return .match
                    case .mismatch(let mismatchResult):
                        if mismatchResult.percentageOfMatching > bestPercentageOfMatching {
                            bestPercentageOfMatching = mismatchResult.percentageOfMatching
                            bestMismatchResult = mismatchResult
                        }
                    }
                    
                    parentPointer = parent.parent
                }
                
                // To get rid of initial value of `bestPercentageOfMatching`
                bestPercentageOfMatching = max(0, bestPercentageOfMatching)
                
                return IsSubviewMatcher.mismatchResult(
                    percentageOfMatching: bestPercentageOfMatching,
                    bestMismatchResult: bestMismatchResult,
                    parentMatcher: parentMatcher
                )
            }
        )
    }
    
    private static func mismatchResult(
        percentageOfMatching: Double,
        bestMismatchResult: MismatchResult?,
        parentMatcher: ElementMatcher)
        -> MatchingResult
    {
        return .partialMismatch(
            percentageOfMatching: percentageOfMatching,
            mismatchDescription: {
                let bestCandidateMismatchDescription: String
                
                // We can't show mismatches for every superview, because when nesting multiple IsSubviewMatcher`s,
                // logging it has exponential complexity, O(N^E) where N - number of views, E - number of nested IsSubviewMatcher`s.
                if let bestMismatchResult = bestMismatchResult {
                    bestCandidateMismatchDescription = "best candidate mismatched: \(bestMismatchResult.mismatchDescription)"
                } else {
                    bestCandidateMismatchDescription = "error occured in IsSubviewMatcher, failed to get best candidate mismatch description"
                }
                
                return """
                found no superview that matches "\(parentMatcher.description)", \
                \(bestCandidateMismatchDescription)
                """
            },
            attachments: {
                if let bestMismatchResult = bestMismatchResult {
                    let bestCandidateAttachments = bestMismatchResult.attachments
                    
                    if bestCandidateAttachments.isEmpty {
                        return []
                    } else {
                        return [
                            Attachment(
                                name: "Best candidate attachments",
                                content: AttachmentContent.attachments(bestCandidateAttachments)
                            )
                        ]
                    }
                } else {
                    return []
                }
            }
        )
    }
}
