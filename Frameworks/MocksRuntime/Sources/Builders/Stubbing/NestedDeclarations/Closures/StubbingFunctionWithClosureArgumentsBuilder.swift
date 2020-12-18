import MixboxFoundation

public class StubbingFunctionWithClosureArgumentsBuilder<TupledArguments, ReturnType, CallClosureStubbingContinuation>:
    StubbingFunctionBuilder<TupledArguments, ReturnType>
    where CallClosureStubbingContinuation: MixboxMocksRuntime.CallClosureStubbingContinuation
{
    private let mockManager: MockManager
    private let functionIdentifier: FunctionIdentifier
    private let recordedCallArgumentsMatcher: RecordedCallArgumentsMatcher
    private let fileLine: FileLine
    
    override public init(
        mockManager: MockManager,
        functionIdentifier: FunctionIdentifier,
        recordedCallArgumentsMatcher: RecordedCallArgumentsMatcher,
        fileLine: FileLine)
    {
        self.mockManager = mockManager
        self.functionIdentifier = functionIdentifier
        self.recordedCallArgumentsMatcher = recordedCallArgumentsMatcher
        self.fileLine = fileLine
        
        super.init(
            mockManager: mockManager,
            functionIdentifier: functionIdentifier,
            recordedCallArgumentsMatcher: recordedCallArgumentsMatcher,
            fileLine: fileLine
        )
    }
    
    public var thenCall: CallClosureStubbingContinuation {
        return CallClosureStubbingContinuation(
            mockManager: mockManager,
            functionIdentifier: functionIdentifier,
            recordedCallArgumentsMatcher: recordedCallArgumentsMatcher,
            fileLine: fileLine
        )
    }
}
