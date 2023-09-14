public final class ArrayContainsElementMatcher<T>: Matcher<[T]> {
    public init(matcher: Matcher<T>) {
        super.init(
            description: {
                """
                contains element that is matched by matcher: \(matcher.wrappedDescription)"
                """
            },
            matchingFunction: { (actualArray: [T]) -> MatchingResult in
                var mismatchResults = [MismatchResult]()
                
                for element in actualArray {
                    let result = matcher.match(value: element)
                    
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
                            expected that array contains element that is matched by "\(matcher.description)", \
                            actual array: \(actualArrayJoined), \
                            mismatch descriptions for elements: \(mismatchDescriptionsJoined)
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
