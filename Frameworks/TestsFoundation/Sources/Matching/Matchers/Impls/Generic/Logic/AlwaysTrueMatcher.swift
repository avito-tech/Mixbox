public class AlwaysTrueMatcher<T>: Matcher<T> {
    public init() {
        super.init(
            description: { "Всегда истинно" },
            matchingFunction: { _ in
                .match
            }
        )
    }
}
