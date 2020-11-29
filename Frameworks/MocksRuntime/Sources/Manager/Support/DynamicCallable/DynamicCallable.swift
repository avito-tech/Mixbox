// Note for Mixbox developers. Here are some ideas for improvements:
// - Support inspecting previous calls
// - Support modification of `inout` variables
// - Support calling non-escaping closures (they are not present in `RecordedCallArguments`)
// - Support inspectiing function signature
// - Support inspecting `self` (callee)
public protocol DynamicCallable {
    func call<ReturnValue>(
        recordedCallArguments: RecordedCallArguments,
        returnValueType: ReturnValue.Type)
        -> DynamicCallableResult<ReturnValue>
}
