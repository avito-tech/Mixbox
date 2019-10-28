public final class ContainsMatcher<T: StringProtocol>: Matcher<T> {
    public init<U: StringProtocol>(string: U) {
        super.init(
            description: {
                "содержит строку \"\(string)\""
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
                            "ожидалось содержание '\(string)' в строке, которая по факту равна '\(actualValue)'"
                        },
                        attachments: { [] }
                    )
                }
            }
        )
    }
}
