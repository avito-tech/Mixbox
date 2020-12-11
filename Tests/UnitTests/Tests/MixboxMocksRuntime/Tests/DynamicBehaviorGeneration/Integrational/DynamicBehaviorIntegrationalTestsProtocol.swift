protocol DynamicBehaviorIntegrationalTestsProtocol {
    func intFunction() -> Int
    func asyncVoidFunction(completion: (Int) -> ())
    func asyncNonVoidFunction(completion: (Int) -> ()) -> Int
    func functionWithClosure(closure: (Int) -> ()) -> Int
}
