import MixboxFoundation
import MixboxTestsFoundation

public final class MockManagerCallingImpl: MockManagerCalling {
    private let testFailureRecorder: TestFailureRecorder
    private let recordedCallsHolder: RecordedCallsHolder
    private let stubsProvider: StubsProvider
    private let dynamicCallable: DynamicCallable
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        recordedCallsHolder: RecordedCallsHolder,
        stubsProvider: StubsProvider,
        dynamicCallable: DynamicCallable)
    {
        self.testFailureRecorder = testFailureRecorder
        self.recordedCallsHolder = recordedCallsHolder
        self.stubsProvider = stubsProvider
        self.dynamicCallable = dynamicCallable
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
    
    // TODO: Support stubbing of throwing/rethrowing functions
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
        } else if let returnValue: ReturnValue = dynamicCallableReturnValue(recordedCallArguments: recordedCallArguments) {
            return returnValue
        } else {
            fail("Call to function \(functionIdentifier) with args \(tupledArguments) and return value of type \(ReturnValue.self) was not stubbed")
        }
    }
    
    private func dynamicCallableReturnValue<ReturnValue>(
        recordedCallArguments: RecordedCallArguments)
        -> ReturnValue?
    {
        let result = dynamicCallable.call(
            recordedCallArguments: recordedCallArguments,
            returnValueType: ReturnValue.self
        )
        
        switch result {
        case let .returned(returnValue):
            return returnValue
        case .canNotProvideResult/*(let error)*/: // TODO: report error?
            return nil
        }
    }
    
    private func fail(_ string: String) -> Never {
        fail(ErrorString(string))
    }

    private func fail(_ error: Error) -> Never {
        testFailureRecorder.recordUnavoidableFailure(description: "\(error)")
    }
}
