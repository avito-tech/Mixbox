import MixboxFoundation
import MixboxTestsFoundation

public final class MockManagerImpl: MockManager {
    private var stubs: [String: [Stub]] = [:]
    private var callRecords: [CallRecord] = []
    private var expectations: [String: [Expectation]] = [:]
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
    
    public func call<Args, ReturnType>(functionId: String, args: Args) -> ReturnType {
        do {
            let callRecord = CallRecord(
                functionId: functionId,
                args: args
            )
            
            callRecords.append(callRecord)
            
            if let stubs = stubs[functionId] {
                for stub in stubs.reversed() {
                    if stub.matcher.valueIsMatching(args) {
                        let returnValueAsAny = stub.closure(args)
                        if let returnValue = returnValueAsAny as? ReturnType {
                            return returnValue
                        } else {
                            throw ErrorString(
                                """
                                Internal error: return value of the stub was expected to be \
                                of type \(ReturnType.self), actual type: \(type(of: returnValueAsAny))
                                """
                            )
                        }
                    }
                }
            }
            
            throw ErrorString("Call to function \(functionId) with args \(args) was not stubbed")
        } catch {
            testFailureRecorder.recordUnavoidableFailure(description: "\(error)")
        }
    }
    
    public func verify() -> VerificationResult {
        var fails = [VerificationFailureDescription]()
        
        for (functionId, expectations) in self.expectations {
            for expectation in expectations {
                var timesCalled: UInt = 0
                for callRecord in callRecords where callRecord.functionId == functionId {
                    if expectation.matcher.valueIsMatching(callRecord.args) {
                        timesCalled += 1
                    }
                }
                
                if !expectation.times.valueIsMatching(timesCalled) {
                    let failureDescription = VerificationFailureDescription(
                        message: "Expectation was not fulfilled",
                        fileLine: expectation.fileLine
                    )
                    fails.append(failureDescription)
                    
                    testFailureRecorder.recordFailure(
                        description: failureDescription.message,
                        shouldContinueTest: true
                    )
                }
            }
        }
        
        if !fails.isEmpty {
            return .fail(fails)
        } else {
            return .success
        }
    }
    
    public func addExpecatation<Args>(functionId: String, fileLine: FileLine, times: FunctionalMatcher<UInt>, matcher: FunctionalMatcher<Args>) {
        let expectation = Expectation(
            matcher: matcher.byErasingType(),
            times: times,
            fileLine: fileLine
        )
        addExpectation(expectation, functionId: functionId)
    }
    
    public func addStub<Args>(functionId: String, closure: @escaping (Any) -> Any, matcher: FunctionalMatcher<Args>) {
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
        if expectations[functionId] != nil {
            expectations[functionId]?.append(expectation)
        } else {
            expectations[functionId] = [expectation]
        }
    }
}
