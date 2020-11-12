public final class Stub {
    public let closure: (Any) -> Any
    public let matcher: FunctionalMatcher<Any>
    
    public init(
        closure: @escaping (Any) -> Any,
        matcher: FunctionalMatcher<Any>)
    {
        self.closure = closure
        self.matcher = matcher
    }
}
