import MixboxFoundation
import MixboxTestsFoundation

public final class MockManagerImpl: MockManager {
    private var stubs: [String: [Stub]] = [:]
    private var callRecords: [CallRecord] = []
    private var expectationsByFunctionId: [String: [Expectation]] = [:]
    private let testFailureRecorder: TestFailureRecorder
    private let fileLine: FileLine
    
    public static let defaultTestFailureRecorder: TestFailureRecorder = XcTestFailureRecorder(
        currentTestCaseProvider: AutomaticCurrentTestCaseProvider(),
        shouldNeverContinueTestAfterFailure: false
    )
    
    public init(
        testFailureRecorder: TestFailureRecorder = defaultTestFailureRecorder,
        fileLine: FileLine)
    {
        self.testFailureRecorder = testFailureRecorder
        self.fileLine = fileLine
    }
    
    public func call<Arguments, ReturnValue>(
        functionId: String,
        arguments: Arguments)
        -> ReturnValue
    {
        do {
            let callRecord = CallRecord(
                functionId: functionId,
                arguments: arguments
            )
            
            callRecords.append(callRecord)
            
            return try stubs[functionId].flatMap { stubs in
                try stubs
                    .last { $0.matches(arguments: arguments) }
                    .map { try $0.value(arguments: arguments) }
            }.unwrapOrThrow(
                error: ErrorString("Call to function \(functionId) with args \(arguments) was not stubbed")
            )
        } catch {
            testFailureRecorder.recordUnavoidableFailure(description: "\(error)")
        }
    }
    
    public func verify() -> VerificationResult {
        let fails: [VerificationFailureDescription] = expectationsByFunctionId.flatMap { (functionId, expectations) in
            expectations.compactMap { expectation in
                let timesCalled = callRecords.mb_count {
                    $0.functionId == functionId
                        && expectation.matcher.valueIsMatching($0.arguments)
                }
                
                if !expectation.times.valueIsMatching(timesCalled) {
                    return VerificationFailureDescription(
                        message: "Expectation was not fulfilled",
                        fileLine: expectation.fileLine
                    )
                } else {
                    return nil
                }
            }
        }
        
        fails.forEach {
            testFailureRecorder.recordFailure(
                description: $0.message,
                shouldContinueTest: true
            )
        }
        
        if !fails.isEmpty {
            return .fail(fails)
        } else {
            return .success
        }
    }
    
    public func addExpecatation<Arguments>(
        functionId: String,
        fileLine: FileLine,
        times: FunctionalMatcher<Int>,
        matcher: FunctionalMatcher<Arguments>)
    {
        let expectation = Expectation(
            matcher: matcher.byErasingType(),
            times: times,
            fileLine: fileLine
        )
        addExpectation(expectation, functionId: functionId)
    }
    
    public func addStub<Arguments>(
        functionId: String,
        closure: @escaping (Any) -> Any,
        matcher: FunctionalMatcher<Arguments>)
    {
        let stub = Stub(
            closure: closure,
            matcher: matcher.byErasingType()
        )
        addStub(stub, functionId: functionId)
    }
    
    private func addStub(_ stub: Stub, functionId: String) {
        if stubs[functionId] != nil {
            stubs[functionId]?.append(stub)
        } else {
            stubs[functionId] = [stub]
        }
    }
    
    private func addExpectation(_ expectation: Expectation, functionId: String) {
        if expectationsByFunctionId[functionId] != nil {
            expectationsByFunctionId[functionId]?.append(expectation)
        } else {
            expectationsByFunctionId[functionId] = [expectation]
        }
    }
}
