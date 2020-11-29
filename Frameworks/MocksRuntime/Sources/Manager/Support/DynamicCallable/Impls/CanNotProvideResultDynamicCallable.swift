public final class CanNotProvideResultDynamicCallable: DynamicCallable {
    private let error: Error
    
    public init(error: Error) {
        self.error = error
    }
    
    public func call<ReturnValue>(
        recordedCallArguments: RecordedCallArguments,
        returnValueType: ReturnValue.Type)
        -> DynamicCallableResult<ReturnValue>
    {
        return .canNotProvideResult(error)
    }
}
