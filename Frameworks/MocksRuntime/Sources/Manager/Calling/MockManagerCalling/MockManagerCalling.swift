public protocol MockManagerCalling {
    func call<Arguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        arguments: Arguments)
        -> ReturnValue
}
