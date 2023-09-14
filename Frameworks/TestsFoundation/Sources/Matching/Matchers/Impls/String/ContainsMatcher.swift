public final class ContainsMatcher<T: StringProtocol>: Matcher<T> {
    public init<U: StringProtocol>(string: U) {
        super.init(
            description: {
                "contains string \"\(string)\""
            },
            matchingFunction: { (actualValue: T) -> MatchingResult in
                let contains: Bool
                
                #if swift(>=4.3)
                contains = actualValue.contains(string)
                #else
                contains = String(actualValue).contains(string)
                #endif
                
                if contains {
                    return .match
                } else {
                    return .exactMismatch(
                        mismatchDescription: {
                            "expected that given string contains '\(string)', but given string is equal to '\(actualValue)'"
                        },
                        attachments: { [] }
                    )
                }
            }
        )
    }
}
