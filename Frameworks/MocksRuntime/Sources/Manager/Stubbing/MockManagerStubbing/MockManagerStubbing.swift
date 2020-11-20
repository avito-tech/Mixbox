public protocol MockManagerStubbing {
    func stub<Arguments>(
        functionIdentifier: FunctionIdentifier,
        closure: @escaping (Any) -> Any,
        argumentsMatcher: FunctionalMatcher<Arguments>)
}
