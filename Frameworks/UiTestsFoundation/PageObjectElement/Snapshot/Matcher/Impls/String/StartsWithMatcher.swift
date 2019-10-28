public final class StartsWithMatcher<T: StringProtocol>: Matcher<T> {
    public init<U: StringProtocol>(string: U) {
        super.init(
            description: {
                """
                начинается со строки "\(string)"
                """
            },
            matchingFunction: { (actualValue: T) -> MatchingResult in
                // TODO: Check this:
                // #if swift(>=4.3)
                // actualValue.startsWith(string)
                
                if String(actualValue).starts(with: string) {
                    return .match
                } else {
                    return .exactMismatch(
                        mismatchDescription: {
                            """
                            ожидалось, что строка начинается с "\(string)"'", актуальное значение строки: "\(actualValue)"
                            """
                        },
                        attachments: { [] }
                    )
                }
            }
        )
    }
}
