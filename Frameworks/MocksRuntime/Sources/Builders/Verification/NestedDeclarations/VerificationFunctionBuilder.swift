import MixboxFoundation
import MixboxTestsFoundation

public final class VerificationFunctionBuilder<Arguments, ReturnType> {
    public typealias Arguments = Arguments
    public typealias ReturnType = ReturnType
    
    private let mockManager: MockManager
    private var functionIdentifier: FunctionIdentifier
    private let recordedCallArgumentsMatcher: RecordedCallArgumentsMatcher
    private let fileLine: FileLine
    
    public init(
        functionIdentifier: FunctionIdentifier,
        mockManager: MockManager,
        recordedCallArgumentsMatcher: RecordedCallArgumentsMatcher,
        fileLine: FileLine)
    {
        self.mockManager = mockManager
        self.functionIdentifier = functionIdentifier
        self.recordedCallArgumentsMatcher = recordedCallArgumentsMatcher
        self.fileLine = fileLine
    }
    
    public func isCalled(
        times: TimesMethodWasCalledMatcher,
        timeout: TimeInterval? = nil,
        pollingInterval: TimeInterval? = nil)
    {
        mockManager.verify(
            functionIdentifier: functionIdentifier,
            fileLine: fileLine,
            timesMethodWasCalledMatcher: times,
            recordedCallArgumentsMatcher: recordedCallArgumentsMatcher,
            timeout: timeout,
            pollingInterval: pollingInterval
        )
    }
    
    public func isCalledOnlyOnce(
        timeout: TimeInterval? = nil,
        pollingInterval: TimeInterval? = nil)
    {
        isCalled(
            times: .exactlyOnce(),
            timeout: timeout,
            pollingInterval: pollingInterval
        )
    }
    
    public func isCalled(
        timeout: TimeInterval? = nil,
        pollingInterval: TimeInterval? = nil)
    {
        isCalled(
            times: .atLeastOnce(),
            timeout: timeout,
            pollingInterval: pollingInterval
        )
    }
    
    public func isNotCalled(
        timeout: TimeInterval? = nil,
        pollingInterval: TimeInterval? = nil)
    {
        isCalled(
            times: .never(),
            timeout: timeout,
            pollingInterval: pollingInterval
        )
    }
    
    // Used to disambiguate return type (must have for generics or overloaded functions; experimental).
    //
    // Example:
    // ```
    // mock.verify().genericFunction().returning(Int.self).isCalled()
    // ```
    //
    // TODO: Make it return a builder without `returning` function.
    //
    public func returning(_ type: ReturnType)
        -> VerificationFunctionBuilder
    {
        return self
    }
}
