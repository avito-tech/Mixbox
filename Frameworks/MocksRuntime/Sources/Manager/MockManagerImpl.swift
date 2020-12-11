import MixboxFoundation
import MixboxTestsFoundation
import MixboxGenerators

public final class MockManagerImpl: MockManager {
    private let stubbing: MockManagerStubbing
    private let calling: MockManagerCalling
    private let verification: MockManagerVerification
    private let stateTransferring: MockManagerStateTransferring
    
    public init(
        stubbing: MockManagerStubbing,
        calling: MockManagerCalling,
        verification: MockManagerVerification,
        stateTransferring: MockManagerStateTransferring)
    {
        self.stubbing = stubbing
        self.calling = calling
        self.verification = verification
        self.stateTransferring = stateTransferring
    }
    
    // MARK: - MockManagerStubbing
    
    public func stub(
        functionIdentifier: FunctionIdentifier,
        callStub: CallStub)
    {
        stubbing.stub(
            functionIdentifier: functionIdentifier,
            callStub: callStub
        )
    }
    
    // MARK: - MockManagerCalling
    
    public func call<MockedType, TupledArguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, TupledArguments) -> ReturnValue,
        tupledArguments: TupledArguments,
        nonEscapingCallArguments: NonEscapingCallArguments,
        generatorSpecializations: [HashableType: TypeErasedAnyGeneratorSpecialization])
        -> ReturnValue
    {
        return calling.call(
            functionIdentifier: functionIdentifier,
            defaultImplementation: defaultImplementation,
            defaultImplementationClosure: defaultImplementationClosure,
            tupledArguments: tupledArguments,
            nonEscapingCallArguments: nonEscapingCallArguments,
            generatorSpecializations: generatorSpecializations
        )
    }
        
    public func callThrows<MockedType, TupledArguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, TupledArguments) throws -> ReturnValue,
        tupledArguments: TupledArguments,
        nonEscapingCallArguments: NonEscapingCallArguments,
        generatorSpecializations: [HashableType: TypeErasedAnyGeneratorSpecialization])
        throws
        -> ReturnValue
    {
        return try calling.callThrows(
            functionIdentifier: functionIdentifier,
            defaultImplementation: defaultImplementation,
            defaultImplementationClosure: defaultImplementationClosure,
            tupledArguments: tupledArguments,
            nonEscapingCallArguments: nonEscapingCallArguments,
            generatorSpecializations: generatorSpecializations
        )
    }
        
    public func callRethrows<MockedType, TupledArguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, TupledArguments) throws -> ReturnValue,
        tupledArguments: TupledArguments,
        nonEscapingCallArguments: NonEscapingCallArguments,
        generatorSpecializations: [HashableType: TypeErasedAnyGeneratorSpecialization])
        rethrows
        -> ReturnValue
    {
        return try calling.callRethrows(
            functionIdentifier: functionIdentifier,
            defaultImplementation: defaultImplementation,
            defaultImplementationClosure: defaultImplementationClosure,
            tupledArguments: tupledArguments,
            nonEscapingCallArguments: nonEscapingCallArguments,
            generatorSpecializations: generatorSpecializations
        )
    }
    
    // MARK: - MockManagerVerification
    
    public func verify(
        functionIdentifier: FunctionIdentifier,
        fileLine: FileLine,
        timesMethodWasCalledMatcher: TimesMethodWasCalledMatcher,
        recordedCallArgumentsMatcher: RecordedCallArgumentsMatcher,
        timeout: TimeInterval?,
        pollingInterval: TimeInterval?)
    {
        verification.verify(
            functionIdentifier: functionIdentifier,
            fileLine: fileLine,
            timesMethodWasCalledMatcher: timesMethodWasCalledMatcher,
            recordedCallArgumentsMatcher: recordedCallArgumentsMatcher,
            timeout: timeout,
            pollingInterval: pollingInterval
        )
    }
    // MARK: - MockManagerStateTransferring
    
    public func transferState(to mockManager: MockManager) {
        stateTransferring.transferState(to: mockManager)
    }
    
    public func appendRecordedCalls(from recordedCallsProvider: RecordedCallsProvider) {
        stateTransferring.appendRecordedCalls(from: recordedCallsProvider)
    }
}
