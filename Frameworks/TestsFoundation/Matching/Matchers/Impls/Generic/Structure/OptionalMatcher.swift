public final class OptionalMatcher<T>: Matcher<T?> {
    public init(
        _ matcher: Matcher<T>?)
    {
        super.init(
            description: {
                if let matcher = matcher {
                    return matcher.description.mb_wrapAndIndent(
                        prefix: "является не nil и {",
                        postfix: "}",
                        ifEmpty: nil
                    )
                } else {
                    return "является nil"
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
                        mismatchDescription: { "ожидалось nil, по факту \(value)" },
                        attachments: { [] }
                    )
                case (.some, .none):
                    return .exactMismatch(
                        mismatchDescription: { "ожидалось не-nil, по факту nil" },
                        attachments: { [] }
                    )
                }
            }
        )
    }
}
