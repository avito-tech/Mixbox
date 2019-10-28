import MixboxTestsFoundation

public final class ArrayContainsElementMatcher<T>: Matcher<[T]> {
    private let matcher: Matcher<T>
    
    public init(matcher: Matcher<T>) {
        self.matcher = matcher
        
        super.init(
            description: {
                """
                содержит элемент, который матчится матчером "\(matcher.description)"
                """
            },
            matchingFunction: { (actualArray: [T]) -> MatchingResult in
                var mismatchResults = [MismatchResult]()
                
                for element in actualArray {
                    let result = matcher.matches(value: element)
                    
                    switch result {
                    case .match:
                        return .match
                    case .mismatch(let mismatchResult):
                        mismatchResults.append(mismatchResult)
                    }
                }
                
                return .exactMismatch(
                    mismatchDescription: {
                        let actualArrayJoined = actualArray
                            .map { "\($0)" }
                            .joined(separator: ",\n")
                            .mb_wrapAndIndent(prefix: "[", postfix: "]", ifEmpty: "[]")
                        
                        let mismatchDescriptionsJoined = mismatchResults
                            .map { "\($0.mismatchDescription)" }
                            .joined(separator: ",\n")
                            .mb_wrapAndIndent(prefix: "[", postfix: "]", ifEmpty: "[]")
                        
                        return """
                            ожидалось содержание элемента, который матчится матчером "\(matcher.description)", \
                            в массиве, актуальный массив: \(actualArrayJoined), \
                            описание ошибок по элементам: \(mismatchDescriptionsJoined)
                            """
                    },
                    attachments: {
                        mismatchResults.enumerated().compactMap { index, mismatchResult in
                            let attachments = mismatchResult.attachments
                            
                            if attachments.isEmpty {
                                return nil
                            } else {
                                return Attachment(
                                    name: "Attachments for element at index #\(index)",
                                    content: .attachments(attachments)
                                )
                            }
                        }
                    }
                )
            }
        )
    }
}
