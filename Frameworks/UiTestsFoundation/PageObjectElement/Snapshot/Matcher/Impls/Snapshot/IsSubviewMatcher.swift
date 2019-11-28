import MixboxFoundation
import MixboxTestsFoundation

public final class IsSubviewMatcher: Matcher<ElementSnapshot> {
    public init(_ parentMatcher: Matcher<ElementSnapshot>) {
        super.init(
            description: {
                parentMatcher.description.mb_wrapAndIndent(
                    prefix: "Является сабвью {",
                    postfix: "}"
                )
            },
            matchingFunction: { snapshot -> MatchingResult in
                var parentPointer = snapshot.parent
                var bestPercentageOfMatching: Double = -Double.greatestFiniteMagnitude
                var bestMismatchResult: MismatchResult?
                
                if parentPointer == nil {
                    return .exactMismatch(
                        mismatchDescription: { "Является сабвью (актуальный результат - не имеет супервью)" },
                        attachments: { [] }
                    )
                }
                
                while let parent = parentPointer {
                    switch parentMatcher.matches(value: parent) {
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
                    bestCandidateMismatchDescription = "лучший кандидат зафейлился: \(bestMismatchResult.mismatchDescription)"
                } else {
                    bestCandidateMismatchDescription = "произошла внутренняя ошибка в IsSubviewMatcher, не удалось получить описание фейла лучшего кандидата"
                }
                
                return """
                не найден superview, который матчится матчером "\(parentMatcher.description)", \
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
