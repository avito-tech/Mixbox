import MixboxFoundation
import MixboxTestsFoundation

public protocol CallClosureStubbingContinuation {
    init(
        mockManager: MockManager,
        functionIdentifier: FunctionIdentifier,
        recordedCallArgumentsMatcher: Matcher<RecordedCallArguments>,
        fileLine: FileLine)
}
