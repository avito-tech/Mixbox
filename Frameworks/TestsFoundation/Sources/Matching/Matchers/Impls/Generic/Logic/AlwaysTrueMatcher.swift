public class AlwaysTrueMatcher<T>: Matcher<T> {
    public init() {
        super.init(
            description: { "Always true" },
            matchingFunction: { _ in
                .match
            }
        )
    }
}
