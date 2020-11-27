import MixboxFoundation

public final class CallStub {
    public let returnValueProvider: (TypeErasedTupledArguments) -> TypeErasedReturnValue
    public let recordedCallArgumentsMatcher: RecordedCallArgumentsMatcher
    
    public init(
        returnValueProvider: @escaping (TypeErasedTupledArguments) -> TypeErasedReturnValue,
        recordedCallArgumentsMatcher: RecordedCallArgumentsMatcher)
    {
        self.returnValueProvider = returnValueProvider
        self.recordedCallArgumentsMatcher = recordedCallArgumentsMatcher
    }
    
    public func matches(recordedCallArguments: RecordedCallArguments) -> Bool {
        return recordedCallArgumentsMatcher.valueIsMatching(recordedCallArguments)
    }
    
    public func value<TupledArguments, ReturnValue>(tupledArguments: TupledArguments) throws -> ReturnValue {
        let typeErasedReturnValue = returnValueProvider(
            TypeErasedTupledArguments(tupledArguments)
        )
        
        return try typeErasedReturnValue.returnValue()
    }
}
