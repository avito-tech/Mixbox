public final class RegularExpressionMatcher<T: StringProtocol>: Matcher<T> {
    public init<U: StringProtocol>(regularExpression: U) {
        super.init(
            description: {
                "текст соответствует регулярке \"\(regularExpression)\""
            },
            matchingFunction: { (actualValue: T) -> MatchingResult in
                let matches: Bool
                
                #if swift(>=4.3)
                matches = actualValue.range(of: regularExpression, options: .regularExpression) != nil
                #else
                matches = String(actualValue).range(of: regularExpression, options: .regularExpression) != nil
                #endif
                
                if matches {
                    return .match
                } else {
                    return .exactMismatch(
                        mismatchDescription: {
                            "текст не прошел проверку регуляркой '\(regularExpression)',"
                                + " актуальный текст: '\(actualValue)'"
                        },
                        attachments: { [] }
                    )
                }
            }
        )
    }
}
