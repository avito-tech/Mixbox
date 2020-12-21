import MixboxFoundation
import MixboxTestsFoundation

public class StubbingFunctionWithClosureArgumentsBuilder<TupledArguments, ReturnType, CallClosureStubbingContinuation>:
    StubbingFunctionBuilder<TupledArguments, ReturnType>
    where CallClosureStubbingContinuation: MixboxMocksRuntime.CallClosureStubbingContinuation
{
    private let mockManager: MockManager
    private let functionIdentifier: FunctionIdentifier
    private let recordedCallArgumentsMatcher: Matcher<RecordedCallArguments>
    private let fileLine: FileLine
    
    override public init(
        mockManager: MockManager,
        functionIdentifier: FunctionIdentifier,
        recordedCallArgumentsMatcher: Matcher<RecordedCallArguments>,
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
