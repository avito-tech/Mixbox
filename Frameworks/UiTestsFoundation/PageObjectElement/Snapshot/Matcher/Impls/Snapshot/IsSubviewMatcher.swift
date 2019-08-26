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
                var mismatchResults = [MismatchResult]()
                var parentPointer = snapshot.parent
                var percentageOfMatching: Double = 0
                
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
                        if mismatchResult.percentageOfMatching > percentageOfMatching {
                            percentageOfMatching = mismatchResult.percentageOfMatching
                        }
                        mismatchResults.append(mismatchResult)
                    }
                    
                    parentPointer = parent.parent
                }
                
                return MatchingResult.mismatch(
                    IsSubviewMatcher.mismatchResult(
                        percentageOfMatching: percentageOfMatching,
                        parentMatcher: parentMatcher,
                        mismatchResults: mismatchResults
                    )
                )
            }
        )
    }
    
    private static func mismatchResult(
        percentageOfMatching: Double,
        parentMatcher: Matcher<ElementSnapshot>,
        mismatchResults: [MismatchResult])
        -> MismatchResult
    {
        return MismatchResult(
            percentageOfMatching: percentageOfMatching,
            mismatchDescription: {
                let sortedMismatchResults = mismatchResults.sorted(by: { left, right -> Bool in
                    left.percentageOfMatching > right.percentageOfMatching
                })
                
                let mismatchDescriptionsJoined = mismatchResults
                    .map { $0.mismatchDescription() }
                    .joined(separator: ",\n")
                    .mb_wrapAndIndent(prefix: "[", postfix: "]", ifEmpty: "[]")
                
                let sortedMismatchResultsMismatchDescriptionsJoined = sortedMismatchResults
                    .map { $0.mismatchDescription() }
                    .joined(separator: ",\n")
                    .mb_wrapAndIndent(prefix: "[", postfix: "]", ifEmpty: "[]")
                
                return """
                Является сабвью - нет, ожидалось содержание родителя, \
                который матчится матчером "\(parentMatcher.description)", \
                описания ошибок по элементам иерархии (по наибольшему соотвествию): \(sortedMismatchResultsMismatchDescriptionsJoined), \
                описания ошибок (от сабвью до супервью): \(mismatchDescriptionsJoined)
                """
            }
        )
    }
}
