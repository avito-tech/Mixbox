import MixboxFoundation
import MixboxTestsFoundation

public final class CallStub {
    public let returnValueProvider: (TypeErasedTupledArguments) -> TypeErasedReturnValue
    public let recordedCallArgumentsMatcher: Matcher<RecordedCallArguments>
    
    public init(
        returnValueProvider: @escaping (TypeErasedTupledArguments) -> TypeErasedReturnValue,
        recordedCallArgumentsMatcher: Matcher<RecordedCallArguments>)
    {
        self.returnValueProvider = returnValueProvider
        self.recordedCallArgumentsMatcher = recordedCallArgumentsMatcher
    }
    
    public func matches(recordedCallArguments: RecordedCallArguments) -> Bool {
        return recordedCallArgumentsMatcher.match(value: recordedCallArguments).matched
    }
    
    public func value<TupledArguments, ReturnValue>(tupledArguments: TupledArguments) throws -> ReturnValue {
        let typeErasedReturnValue = returnValueProvider(
            TypeErasedTupledArguments(tupledArguments)
        )
        
        return try typeErasedReturnValue.returnValue()
    }
}
