import MixboxFoundation
import MixboxTestsFoundation

open class StubbingFunctionBuilder<TupledArguments, ReturnType> {
    public typealias TupledArguments = TupledArguments
    public typealias ReturnType = ReturnType
    
    private let mockManager: MockManager
    private let functionIdentifier: FunctionIdentifier
    private let recordedCallArgumentsMatcher: Matcher<RecordedCallArguments>
    private let fileLine: FileLine
    
    public init(
        mockManager: MockManager,
        functionIdentifier: FunctionIdentifier,
        recordedCallArgumentsMatcher: Matcher<RecordedCallArguments>,
        fileLine: FileLine)
    {
        self.mockManager = mockManager
        self.functionIdentifier = functionIdentifier
        self.recordedCallArgumentsMatcher = recordedCallArgumentsMatcher
        self.fileLine = fileLine
    }
    
    public func thenReturn(_ result: ReturnType) {
        mockManager.stub(
            functionIdentifier: functionIdentifier,
            callStub: CallStub(
                returnValueProvider: { _ in TypeErasedReturnValue(result) },
                recordedCallArgumentsMatcher: recordedCallArgumentsMatcher
            )
        )
    }
    
    public func thenInvoke(_ closure: @escaping (TupledArguments) -> ReturnType) {
        mockManager.stub(
            functionIdentifier: functionIdentifier,
            callStub: CallStub(
                returnValueProvider: { [fileLine] typeErasedTupledArguments in
                    UnavoidableFailure.doOrFail(fileLine: fileLine) {
                        let tupledArguments: TupledArguments = try typeErasedTupledArguments.tupledArguments()
                        return TypeErasedReturnValue(
                            closure(tupledArguments)
                        )
                    }
                },
                recordedCallArgumentsMatcher: recordedCallArgumentsMatcher
            )
        )
    }
}

extension StubbingFunctionBuilder where ReturnType == Void {
    public func thenDoNothing() {
        thenReturn(())
    }
}
