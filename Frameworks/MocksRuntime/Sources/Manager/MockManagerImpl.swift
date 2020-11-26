import MixboxFoundation
import MixboxTestsFoundation

public final class MockManagerImpl: MockManager {
    private let stubbing: MockManagerStubbing
    private let calling: MockManagerCalling
    private let verification: MockManagerVerification
    private let stateTransferring: MockManagerStateTransferring
    private let mockedInstanceInfoSettable: MockedInstanceInfoSettable
    
    public init(
        stubbing: MockManagerStubbing,
        calling: MockManagerCalling,
        verification: MockManagerVerification,
        stateTransferring: MockManagerStateTransferring,
        mockedInstanceInfoSettable: MockedInstanceInfoSettable)
    {
        self.stubbing = stubbing
        self.calling = calling
        self.verification = verification
        self.stateTransferring = stateTransferring
        self.mockedInstanceInfoSettable = mockedInstanceInfoSettable
    }
    
    // MARK: - MockManagerStubbing
    
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
    
    // MARK: - MockManagerCalling
    
    public func call<MockedType, Arguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, Arguments) -> ReturnValue,
        arguments: Arguments)
        -> ReturnValue
    {
        return calling.call(
            functionIdentifier: functionIdentifier,
            defaultImplementation: defaultImplementation,
            defaultImplementationClosure: defaultImplementationClosure,
            arguments: arguments
        )
    }
        
    public func callThrows<MockedType, Arguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, Arguments) throws -> ReturnValue,
        arguments: Arguments)
        throws
        -> ReturnValue
    {
        return try calling.callThrows(
            functionIdentifier: functionIdentifier,
            defaultImplementation: defaultImplementation,
            defaultImplementationClosure: defaultImplementationClosure,
            arguments: arguments
        )
    }
        
    public func callRethrows<MockedType, Arguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, Arguments) throws -> ReturnValue,
        arguments: Arguments)
        rethrows
        -> ReturnValue
    {
        return try calling.callRethrows(
            functionIdentifier: functionIdentifier,
            defaultImplementation: defaultImplementation,
            defaultImplementationClosure: defaultImplementationClosure,
            arguments: arguments
        )
    }
    
    // MARK: - MockManagerVerification
    
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
    // MARK: - MockManagerStateTransferring
    
    public func transferState(to mockManager: MockManager) {
        stateTransferring.transferState(to: mockManager)
    }
    
    public func appendCallRecords(from callRecordsProvider: CallRecordsProvider) {
        stateTransferring.appendCallRecords(from: callRecordsProvider)
    }
    
    // MARK: - MockedInstanceInfoSettable
    
    public func setMockedInstanceInfo(_ mockedInstanceInfo: MockedInstanceInfo) {
        mockedInstanceInfoSettable.setMockedInstanceInfo(mockedInstanceInfo)
    }
}
