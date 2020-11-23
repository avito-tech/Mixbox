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
        do {
            let callRecord = CallRecord(
                functionIdentifier: functionIdentifier,
                arguments: arguments
            )
            
            callRecordsHolder.callRecords.append(callRecord)
            
            // TODO: File a bug to https://bugs.swift.org/
            // Swift crashes if I remove `: ReturnValue?` annotation.
            let returnValueOrNil: ReturnValue? = try stubsProvider.stubs[functionIdentifier].flatMap { stubs in
                try stubs
                    .last { $0.matches(arguments: arguments) }
                    .map { try $0.value(arguments: arguments) }
            }
            
            if let returnValue = returnValueOrNil {
                return returnValue
            } else if var defaultImplementation = defaultImplementation {
                return defaultImplementationClosure(&defaultImplementation, arguments)
            } else {
                throw ErrorString(
                    "Call to function \(functionIdentifier) with args \(arguments) was not stubbed"
                )
            }
        } catch {
            testFailureRecorder.recordUnavoidableFailure(description: "\(error)")
        }
    }
    
    public func callThrows<MockedType, Arguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, Arguments) throws -> ReturnValue,
        arguments: Arguments)
        throws
        -> ReturnValue
    {
        preconditionFailure("Not implemented")
    }
        
    public func callRethrows<MockedType, Arguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        defaultImplementation: MockedType?,
        defaultImplementationClosure: (inout MockedType, Arguments) throws -> ReturnValue,
        arguments: Arguments)
        rethrows
        -> ReturnValue
    {
        preconditionFailure("Not implemented")
    }
}
