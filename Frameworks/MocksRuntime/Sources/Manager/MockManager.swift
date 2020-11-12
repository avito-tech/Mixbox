import MixboxFoundation

public protocol MockManager: class {
    func call<Args, ReturnType>(
        functionId: String,
        args: Args)
        -> ReturnType
    
    func verify() -> VerificationResult
    
    func addStub<Args>(
        functionId: String,
        closure: @escaping (Any) -> Any,
        matcher: FunctionalMatcher<Args>
    )
    
    func addExpecatation<Args>(
        functionId: String,
        fileLine: FileLine,
        times: FunctionalMatcher<UInt>,
        matcher: FunctionalMatcher<Args>
    )
}
