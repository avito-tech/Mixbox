import MixboxFoundation

// Easy to implement customization of `AnyGeneratorDynamicCallable`,
// is used inside `AnyGeneratorDynamicCallable`, which is `DynamicCallable`.
//
// It will be more high level than implementing `DynamicCallable` from scratch.
//
public protocol AnyGeneratorDynamicCallableBehavior {
    func call<ReturnValue>(
        arguments: [AnyGeneratorDynamicCallableFunctionArgument],
        returnValueType: ReturnValue.Type)
        throws
        -> CustomizableScalar<ThrowingFunctionResult<ReturnValue>>
}
