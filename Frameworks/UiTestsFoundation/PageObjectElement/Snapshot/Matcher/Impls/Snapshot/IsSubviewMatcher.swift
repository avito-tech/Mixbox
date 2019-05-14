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
                var results = [MatchingResult]()
                
                var parentPointer = snapshot.parent
                while let parent = parentPointer {
                    let matchingResult = parentMatcher.matches(value: parent)
                    results.append(matchingResult)
                    
                    if matchingResult.matched {
                        return .match
                    }
                    parentPointer = parent.parent
                }
                
                // TODO: Optimize.
                results.sort(by: { left, right -> Bool in
                    left.percentageOfMatching > right.percentageOfMatching
                })
                
                if let bestMatch = results.first {
                    switch bestMatch {
                    case .match:
                        return .match
                    case let .mismatch(percentageOfMatching, mismatchDescription):
                        return MatchingResult.partialMismatch(
                            percentageOfMatching: percentageOfMatching,
                            mismatchDescription: {
                                "Является сабвью - нет, лучший кандидат зафейлился " + mismatchDescription()
                            }
                        )
                    }
                } else {
                    return MatchingResult.exactMismatch(
                        mismatchDescription: { "Является сабвью (актуальный результат - не имеет супервью)" }
                    )
                }
            }
        )
    }
}
