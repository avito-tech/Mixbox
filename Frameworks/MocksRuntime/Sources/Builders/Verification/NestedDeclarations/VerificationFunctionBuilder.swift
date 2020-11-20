import MixboxFoundation
import MixboxTestsFoundation

public final class VerificationFunctionBuilder<Arguments, ReturnType> {
    public typealias Arguments = Arguments
    public typealias ReturnType = ReturnType
    
    private let mockManager: MockManager
    private var functionIdentifier: FunctionIdentifier
    private let argumentsMatcher: FunctionalMatcher<Arguments>
    private let fileLine: FileLine
    
    public init(
        functionIdentifier: FunctionIdentifier,
        mockManager: MockManager,
        argumentsMatcher: FunctionalMatcher<Arguments>,
        fileLine: FileLine)
    {
        self.mockManager = mockManager
        self.functionIdentifier = functionIdentifier
        self.argumentsMatcher = argumentsMatcher
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
            argumentsMatcher: argumentsMatcher,
            timeout: timeout,
            pollingInterval: pollingInterval
        )
    }
    
    public func isCalled(timeout: TimeInterval? = nil, pollingInterval: TimeInterval? = nil) {
        isCalled(
            times: .atLeastOnce(),
            timeout: timeout,
            pollingInterval: pollingInterval
        )
    }
    
    public func isNotCalled(timeout: TimeInterval? = nil, pollingInterval: TimeInterval? = nil) {
        isCalled(
            times: .never(),
            timeout: timeout,
            pollingInterval: pollingInterval
        )
    }
}
