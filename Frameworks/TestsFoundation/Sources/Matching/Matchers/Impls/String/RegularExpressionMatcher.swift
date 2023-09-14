import MixboxFoundation

public final class RegularExpressionMatcher<T: StringProtocol>: Matcher<T> {
    public init(
        pattern: String,
        regularExpressionCompilationResult: Result<NSRegularExpression, Error>
    ) {
        super.init(
            description: {
                "text matches regular expression \"\(pattern)\""
            },
            matchingFunction: { (actualValue: T) -> MatchingResult in
                switch regularExpressionCompilationResult {
                case let .success(regularExpression):
                    let actualValue = String(actualValue)
                    
                    let firstMatch = regularExpression.firstMatch(
                        in: actualValue,
                        range: NSRange(
                            location: 0,
                            length: (actualValue as NSString).length
                        )
                    )
                    
                    if firstMatch != nil {
                        return .match
                    } else {
                        return .exactMismatch(
                            mismatchDescription: {
                                "string doesn't match regular expression '\(pattern)',"
                                    + " actual string: '\(actualValue)'"
                            },
                            attachments: { [] }
                        )
                    }
                case let .failure(error):
                    return .exactMismatch(
                        mismatchDescription: {
                            "regular expression '\(pattern)' failed to compile: \(error)"
                        },
                        attachments: { [] }
                    )
                }
            }
        )
    }
    
    public convenience init(
        regularExpression: NSRegularExpression
    ) {
        self.init(
            pattern: regularExpression.pattern,
            regularExpressionCompilationResult: .success(regularExpression)
        )
    }
    
    public convenience init<U: StringProtocol>(
        regularExpression pattern: U,
        options: NSRegularExpression.Options = []
    ) {
        let pattern = String(pattern)
        
        do {
            self.init(
                pattern: pattern,
                regularExpressionCompilationResult: .success(
                    try NSRegularExpression(
                        pattern: pattern,
                        options: options
                    )
                )
            )
        } catch {
            self.init(
                pattern: pattern,
                regularExpressionCompilationResult: .failure(error)
            )
        }
    }
}
