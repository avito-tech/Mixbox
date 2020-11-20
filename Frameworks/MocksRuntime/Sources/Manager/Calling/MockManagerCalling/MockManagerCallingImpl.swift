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
    
    public func call<Arguments, ReturnValue>(
        functionIdentifier: FunctionIdentifier,
        arguments: Arguments)
        -> ReturnValue
    {
        do {
            let callRecord = CallRecord(
                functionIdentifier: functionIdentifier,
                arguments: arguments
            )
            
            callRecordsHolder.callRecords.append(callRecord)
            
            return try stubsProvider.stubs[functionIdentifier].flatMap { stubs in
                try stubs
                    .last { $0.matches(arguments: arguments) }
                    .map { try $0.value(arguments: arguments) }
            }.unwrapOrThrow(
                error: ErrorString("Call to function \(functionIdentifier) with args \(arguments) was not stubbed")
            )
        } catch {
            testFailureRecorder.recordUnavoidableFailure(description: "\(error)")
        }
    }
}
