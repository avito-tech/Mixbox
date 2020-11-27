import MixboxFoundation
import MixboxTestsFoundation

public final class MockManagerCallingImpl: MockManagerCalling {
    private let testFailureRecorder: TestFailureRecorder
    private let recordedCallsHolder: RecordedCallsHolder
    private let stubsProvider: StubsProvider
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        recordedCallsHolder: RecordedCallsHolder,
        stubsProvider: StubsProvider)
    {
        self.testFailureRecorder = testFailureRecorder
        self.recordedCallsHolder = recordedCallsHolder
        self.stubsProvider = stubsProvider
    }
    
    public func call<MockedType, TupledArguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, TupledArguments) -> ReturnValue,
        tupledArguments: TupledArguments,
        recordedCallArguments: RecordedCallArguments)
        -> ReturnValue
    {
        return callAny(
            functionIdentifier: functionIdentifier,
            defaultImplementation: defaultImplementation,
            defaultImplementationClosure: defaultImplementationClosure,
            tupledArguments: tupledArguments,
            recordedCallArguments: recordedCallArguments
        )
    }
    
    public func callThrows<MockedType, TupledArguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, TupledArguments) throws -> ReturnValue,
        tupledArguments: TupledArguments,
        recordedCallArguments: RecordedCallArguments)
        throws
        -> ReturnValue
    {
        return try callAny(
            functionIdentifier: functionIdentifier,
            defaultImplementation: defaultImplementation,
            defaultImplementationClosure: defaultImplementationClosure,
            tupledArguments: tupledArguments,
            recordedCallArguments: recordedCallArguments
        )
    }
        
    public func callRethrows<MockedType, TupledArguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, TupledArguments) throws -> ReturnValue,
        tupledArguments: TupledArguments,
        recordedCallArguments: RecordedCallArguments)
        rethrows
        -> ReturnValue
    {
        return try callAny(
            functionIdentifier: functionIdentifier,
            defaultImplementation: defaultImplementation,
            defaultImplementationClosure: defaultImplementationClosure,
            tupledArguments: tupledArguments,
            recordedCallArguments: recordedCallArguments
        )
    }
    
    // TODO: Support stubbing of throwing
    private func callAny<MockedType, TupledArguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, TupledArguments) throws -> ReturnValue,
        tupledArguments: TupledArguments,
        recordedCallArguments: RecordedCallArguments)
        rethrows
        -> ReturnValue
    {
        let recordedCall = RecordedCall(
            functionIdentifier: functionIdentifier,
            arguments: recordedCallArguments
        )
        
        recordedCallsHolder.recordedCalls.append(recordedCall)

        let returnValueOrNil: ReturnValue?
        do {
            returnValueOrNil = try stubsProvider.stubs[functionIdentifier].flatMap { stubs in
                try stubs
                    .last { $0.matches(recordedCallArguments: recordedCallArguments) }
                    .map { try $0.value(tupledArguments: tupledArguments) }
            }
        } catch {
            fail(error)
        }
            
        if let returnValue = returnValueOrNil {
            return returnValue
        } else if var defaultImplementation = defaultImplementation {
            return try defaultImplementationClosure(&defaultImplementation, tupledArguments)
        } else {
            fail("Call to function \(functionIdentifier) with args \(tupledArguments) was not stubbed")
        }
    }
    
    private func fail(_ string: String) -> Never {
        fail(ErrorString(string))
    }

    private func fail(_ error: Error) -> Never {
        testFailureRecorder.recordUnavoidableFailure(description: "\(error)")
    }
}
