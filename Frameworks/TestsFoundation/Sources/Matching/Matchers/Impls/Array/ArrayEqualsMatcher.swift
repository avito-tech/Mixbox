public final class ArrayEqualsMatcher<T>: Matcher<[T]> {
    // swiftlint:disable:next function_body_length
    public init(matchers: [Matcher<T>]) {
        super.init(
            description: {
                let matcherDescriptions = matchers
                    .map { "'\($0.description)'" }
                    .joined(separator: ", ")
                
                return """
                array matches matchers [\(matcherDescriptions)]"
                """
            },
            matchingFunction: { (actualArray: [T]) -> MatchingResult in
                guard actualArray.count == matchers.count else {
                    return .exactMismatch(
                        mismatchDescription: {
                            """
                            array does not match, \
                            expected count: \(matchers.count), \
                            actual count: \(actualArray.count)
                            """
                        },
                        attachments: { [] }
                    )
                }
                
                // To avoid division by zero later
                if actualArray.isEmpty {
                    return .match
                }
                
                var enumeratedMismatchResults = [(Int, MismatchResult)]()
                
                for (index, zipped) in zip(actualArray, matchers).enumerated() {
                    let (element, matcher) = zipped
                    
                    let result = matcher.match(value: element)
                    
                    switch result {
                    case .match:
                        break
                    case .mismatch(let mismatchResult):
                        enumeratedMismatchResults.append((index, mismatchResult))
                    }
                }
                
                if enumeratedMismatchResults.isEmpty {
                    return .match
                } else {
                    return .partialMismatch(
                        percentageOfMatching: Double(enumeratedMismatchResults.count) / Double(actualArray.count),
                        mismatchDescription: {
                            let actualArrayJoined = actualArray
                                .map { "\($0)" }
                                .joined(separator: ",\n")
                                .mb_wrapAndIndent(prefix: "[", postfix: "]", ifEmpty: "[]")
                            
                            let mismatchDescriptionsJoined = enumeratedMismatchResults
                                .map { "\($0.1.mismatchDescription)" }
                                .joined(separator: ",\n")
                                .mb_wrapAndIndent(prefix: "[", postfix: "]", ifEmpty: "[]")
                            
                            return """
                                arrays don't match, \
                                actualArray: \(actualArrayJoined), \
                                mismatches by elements: \(mismatchDescriptionsJoined)
                                """
                        },
                        attachments: {
                            enumeratedMismatchResults.compactMap { index, mismatchResult in
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
            }
        )
    }
}
