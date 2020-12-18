import MixboxFoundation

public protocol CallClosureStubbingContinuation {
    init(
        mockManager: MockManager,
        functionIdentifier: FunctionIdentifier,
        recordedCallArgumentsMatcher: RecordedCallArgumentsMatcher,
        fileLine: FileLine)
}
