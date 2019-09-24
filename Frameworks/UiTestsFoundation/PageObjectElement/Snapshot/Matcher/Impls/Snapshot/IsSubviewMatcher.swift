import MixboxFoundation

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
                var bestPercentageOfMatching: Double = 0
                var bestMismatchResult: MismatchResult?
                
                if parentPointer == nil {
                    return MatchingResult.exactMismatch(
                        mismatchDescription: { "Является сабвью (актуальный результат - не имеет супервью)" }
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
                
                return MatchingResult.mismatch(
                    IsSubviewMatcher.mismatchResult(
                        percentageOfMatching: bestPercentageOfMatching,
                        bestMismatchResult: bestMismatchResult,
                        parentMatcher: parentMatcher
                    )
                )
            }
        )
    }
    
    private static func mismatchResult(
        percentageOfMatching: Double,
        bestMismatchResult: MismatchResult?,
        parentMatcher: ElementMatcher)
        -> MismatchResult
    {
        return MismatchResult(
            percentageOfMatching: percentageOfMatching,
            mismatchDescription: {
                let bestCandidateMismatchDescription: String
                
                // We can't show mismatches for every superview, because when nesting multiple IsSubviewMatcher`s,
                // logging it has exponential complexity, O(N^E) where N - number of views, E - number of nested IsSubviewMatcher`s.
                if let bestMismatchResult = bestMismatchResult {
                    bestCandidateMismatchDescription = "лучший кандидат зафейлился: \(bestMismatchResult.mismatchDescription())"
                } else {
                    bestCandidateMismatchDescription = "произошла внутренняя ошибка в IsSubviewMatcher, не удалось получить описание фейла лучшего кандидата"
                }
                
                return """
                Является сабвью - нет, ожидалось содержание родителя, \
                который матчится матчером "\(parentMatcher.description)", \
                \(bestCandidateMismatchDescription)
                """
            }
        )
    }
}
