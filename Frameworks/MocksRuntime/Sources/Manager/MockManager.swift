import MixboxFoundation

public protocol MockManager: class {
    func call<Arguments, ReturnValue>(
        functionId: String,
        arguments: Arguments)
        -> ReturnValue
    
    func verify() -> VerificationResult
    
    func addStub<Arguments>(
        functionId: String,
        closure: @escaping (Any) -> Any,
        matcher: FunctionalMatcher<Arguments>
    )
    
    func addExpecatation<Arguments>(
        functionId: String,
        fileLine: FileLine,
        times: FunctionalMatcher<Int>,
        matcher: FunctionalMatcher<Arguments>)
}
