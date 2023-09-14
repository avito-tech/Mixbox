public final class StartsWithMatcher<T: StringProtocol>: Matcher<T> {
    public init<U: StringProtocol>(string: U) {
        super.init(
            description: {
                """
                starts with string "\(string)"
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
                            expected that string starts with "\(string)"'", actual value: "\(actualValue)"
                            """
                        },
                        attachments: { [] }
                    )
                }
            }
        )
    }
}
