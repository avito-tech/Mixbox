import MixboxFoundation
import MixboxTestsFoundation

public final class MockManagerCallingImpl: MockManagerCalling {
    private let testFailureRecorder: TestFailureRecorder
    private let callRecordsHolder: CallRecordsHolder
    private let stubsProvider: StubsProvider
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        callRecordsHolder: CallRecordsHolder,
        stubsProvider: StubsProvider)
    {
        self.testFailureRecorder = testFailureRecorder
        self.callRecordsHolder = callRecordsHolder
        self.stubsProvider = stubsProvider
    }
    
    public func call<MockedType, Arguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, Arguments) -> ReturnValue,
        arguments: Arguments)
        -> ReturnValue
    {
        return callAny(
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
        return try callAny(
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
        return try callAny(
            functionIdentifier: functionIdentifier,
            defaultImplementation: defaultImplementation,
            defaultImplementationClosure: defaultImplementationClosure,
            arguments: arguments
        )
    }
    
    // TODO: Support stubbing of throwing
    private func callAny<MockedType, Arguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, Arguments) throws -> ReturnValue,
        arguments: Arguments)
        rethrows
        -> ReturnValue
    {
        let callRecord = CallRecord(
            functionIdentifier: functionIdentifier,
            arguments: arguments
        )
        
        callRecordsHolder.callRecords.append(callRecord)

        let returnValueOrNil: ReturnValue?
        do {
            returnValueOrNil = try stubsProvider.stubs[functionIdentifier].flatMap { stubs in
                try stubs
                    .last { $0.matches(arguments: arguments) }
                    .map { try $0.value(arguments: arguments) }
            }
        } catch {
            fail(error)
        }
            
        if let returnValue = returnValueOrNil {
            return returnValue
        } else if var defaultImplementation = defaultImplementation {
            return try defaultImplementationClosure(&defaultImplementation, arguments)
        } else {
            fail("Call to function \(functionIdentifier) with args \(arguments) was not stubbed")
        }
    }
    
    private func fail(_ string: String) -> Never {
        fail(ErrorString(string))
    }

    private func fail(_ error: Error) -> Never {
        testFailureRecorder.recordUnavoidableFailure(description: "\(error)")
    }
}
