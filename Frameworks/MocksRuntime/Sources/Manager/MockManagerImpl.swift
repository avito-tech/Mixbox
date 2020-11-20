import MixboxFoundation
import MixboxTestsFoundation

public final class MockManagerImpl: MockManager {
    private let stubbing: MockManagerStubbing
    private let calling: MockManagerCalling
    private let verification: MockManagerVerification
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        waiter: RunLoopSpinningWaiter,
        defaultTimeout: TimeInterval = 15,
        defaultPollingInterval: TimeInterval = 0.1)
    {
        let stubsHolder = StubsHolderImpl()
        let callRecordsHolder = CallRecordsHolderImpl()
        
        self.stubbing = MockManagerStubbingImpl(
            stubsHolder: stubsHolder
        )
        self.calling = MockManagerCallingImpl(
            testFailureRecorder: testFailureRecorder,
            callRecordsHolder: callRecordsHolder,
            stubsProvider: stubsHolder
        )
        self.verification = MockManagerVerificationImpl(
            testFailureRecorder: testFailureRecorder,
            callRecordsProvider: callRecordsHolder,
            waiter: waiter,
            defaultTimeout: defaultTimeout,
            defaultPollingInterval: defaultPollingInterval
        )
    }
    
    public func call<Arguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        arguments: Arguments)
        -> ReturnValue
    {
        calling.call(
            functionIdentifier: functionIdentifier,
            arguments: arguments
        )
    }
    
    public func verify<Arguments>(
        functionIdentifier: FunctionIdentifier,
        fileLine: FileLine,
        timesMethodWasCalledMatcher: TimesMethodWasCalledMatcher,
        argumentsMatcher: FunctionalMatcher<Arguments>,
        timeout: TimeInterval?,
        pollingInterval: TimeInterval?)
    {
        verification.verify(
            functionIdentifier: functionIdentifier,
            fileLine: fileLine,
            timesMethodWasCalledMatcher: timesMethodWasCalledMatcher,
            argumentsMatcher: argumentsMatcher,
            timeout: timeout,
            pollingInterval: pollingInterval
        )
    }
    
    public func stub<Arguments>(
        functionIdentifier: FunctionIdentifier,
        closure: @escaping (Any) -> Any,
        argumentsMatcher: FunctionalMatcher<Arguments>)
    {
        stubbing.stub(
            functionIdentifier: functionIdentifier,
            closure: closure,
            argumentsMatcher: argumentsMatcher
        )
    }
}
