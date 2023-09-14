public final class OptionalMatcher<T>: Matcher<T?> {
    public init(
        _ matcher: Matcher<T>?)
    {
        super.init(
            description: {
                if let matcher = matcher {
                    return matcher.description.mb_wrapAndIndent(
                        prefix: "is not nil and {",
                        postfix: "}",
                        ifEmpty: nil
                    )
                } else {
                    return "is nil"
                }
            },
            matchingFunction: { value in
                switch (matcher, value) {
                case (.none, .none):
                    return .match
                case let (.some(matcher), .some(value)):
                    return matcher.match(value: value)
                case let (.none, .some(value)):
                    return .exactMismatch(
                        mismatchDescription: { "expected nil, actual value: \(value)" },
                        attachments: { [] }
                    )
                case (.some, .none):
                    return .exactMismatch(
                        mismatchDescription: { "expected non-nil, actual value: nil" },
                        attachments: { [] }
                    )
                }
            }
        )
    }
}
