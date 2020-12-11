// Note for Mixbox developers. Here are some ideas for improvements:
// - Support inspecting previous calls
// - Support modification of `inout` variables
// - Support calling non-escaping closures (they are not present in `NonEscapingCallArguments`)
// - Support inspectiing function signature
// - Support inspecting `self` (callee)
public protocol DynamicCallable {
    func call<ReturnValue>(
        nonEscapingCallArguments: NonEscapingCallArguments,
        returnValueType: ReturnValue.Type)
        -> DynamicCallableResult<ReturnValue>
}
