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
                        skipIfEmpty: false
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
                    return matcher.matches(value: value)
                case let (.none, .some(value)):
                    return .exactMismatch { "ожидалось nil, по факту \(value)" }
                case (.some, .none):
                    return .exactMismatch { "ожидалось не-nil, по факту nil" }
                }
            }
        )
    }
}
