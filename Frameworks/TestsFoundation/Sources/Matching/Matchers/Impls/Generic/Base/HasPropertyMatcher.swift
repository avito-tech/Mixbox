public final class HasPropertyMatcher<T, U>: Matcher<T> {
    public init(property: @escaping (T) -> (U), name: String, matcher: Matcher<U>) {
        super.init(
            description: {
                """
                has property "\(name)": \(matcher.description)
                """
            },
            matchingFunction: { container in
                matcher.match(value: property(container))
            }
        )
    }
}
